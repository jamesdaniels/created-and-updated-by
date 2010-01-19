module CreatedAndUpdatedBy	
	class Stamper
		cattr_accessor :stampable, :attribute
		def self.attach(stamp_model = User, stamp_attribute = :current)
			raise ArgumentError, "#{stamp_model.name} does not respond to #{stamp_attribute}" unless stamp_model.respond_to?(stamp_attribute)
			self.stampable, self.attribute = stamp_model, stamp_attribute
			ActiveRecord::Base.send(:include, CreatedAndUpdatedBy)
		end
	end
	class_eval do
		def stamper
			CreatedAndUpdatedBy::Stamper.stampable.send(CreatedAndUpdatedBy::Stamper.attribute)
		end
		def updated_by; CreatedAndUpdatedBy::Stamper.stampable.find(updated_by_id); end
		def created_by; CreatedAndUpdatedBy::Stamper.stampable.find(updated_by_id); end
		def set_stamps
			self.created_by_id ||= self.updated_by_id = stamper.id if stamper && respond_to?(:created_by_id) && respond_to?(:updated_by_id)
		end
	end	
end