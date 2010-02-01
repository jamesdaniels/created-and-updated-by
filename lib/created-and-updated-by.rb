require 'rubygems'
require 'active_support'
require 'active_support/core_ext'

module CreatedAndUpdatedBy
	class Stamper
		include ActiveSupport::CoreExtensions
		cattr_accessor :stampable, :attribute
		def self.attach(stamp_model = :User, stamp_attribute = :current)
			raise ArgumentError, "#{stamp_model} does not respond to #{stamp_attribute}" unless Object.const_get(stamp_model).respond_to?(stamp_attribute)
			self.stampable, self.attribute = stamp_model, stamp_attribute
			ActiveRecord::Base.send(:include, CreatedAndUpdatedBy)
		end
	end
	def self.included(base)
		base.class_eval [
			"send :include, InstanceMethods",
			"before_validation :set_stamps",
			"belongs_to :updated_by, :class_name => '#{CreatedAndUpdatedBy::Stamper.stampable}'",
			"belongs_to :created_by, :class_name => '#{CreatedAndUpdatedBy::Stamper.stampable}'",
		].join("\n")
	end
	module InstanceMethods
		def stamper; Object.const_get(CreatedAndUpdatedBy::Stamper.stampable).send(CreatedAndUpdatedBy::Stamper.attribute); end
		def set_stamps
			if stamper && stamper.respond_to?(:id) && respond_to?(:created_by_id) && respond_to?(:updated_by_id)
				self.created_by_id = stamper.id if new_record?
				self.updated_by_id = stamper.id if changed?
			end
		end
	end
end