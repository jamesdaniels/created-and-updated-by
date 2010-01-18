module CreatedAndUpdatedBy
	
	class Stamper
		cattr_accessor :stampable, :attribute
		def self.attach(stamp_model = User, stamp_attribute = :current)
			raise ArgumentError, "#{stamp_model.name} does not respond to #{stamp_attribute}" unless stamp_model.respond_to?(stamp_attribute)
			self.stampable, self.attribute = stamp_model, stamp_attribute
			ActiveRecord::Base.extend CreatedAndUpdatedBy  
			ActiveRecord::Base.send(:acts_as_stampable)
		end
	end
	
	def acts_as_stampable
		class_eval do
			send :include, InstanceMethods
			before_validation :set_stamps
			belongs_to :updated_by, :class_name => CreatedAndUpdatedBy::Stamper.stampable.name
			belongs_to :created_by, :class_name => CreatedAndUpdatedBy::Stamper.stampable.name
		end
	end
	
	module InstanceMethods
		def stamper
			CreatedAndUpdatedBy::Stamper.stampable.send(CreatedAndUpdatedBy::Stamper.attribute)
		end
		def set_stamps
			if stamper && respond_to?(:created_by_id) && respond_to?(:updated_by_id)
				self.created_by ||= stamper
				self.updated_by = stamper
			end
		end
	end   
	
end