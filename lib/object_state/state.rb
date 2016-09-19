require 'active_model'
require 'virtus'

module ObjectState
  class State
    class UnsupportedAttributeType < StandardError; end

    include ActiveModel::Model
    include ActiveSupport::Rescuable
    include Virtus.model(nullify_blank: true)

    attr_accessor :model

    validates :model, presence: true

    def self.attribute_names
      attribute_set.map(&:name)
    end

    def self.setup_attributes(owner_class, &block)
      temp_class = Class.new(Object)

      # override attr_accessor to collect attr_accessor :names
      temp_class.define_singleton_method :attr_accessor do |*names|
        @attr_accessor_names ||= []
        @attr_accessor_names.concat Array(names)
        super(*names)
      end

      temp_class.define_singleton_method :attr_accessor_names do
        Array(@attr_accessor_names)
      end

      is_mongoid_document = !!defined?(::Mongoid::Document) && owner_class.ancestors.include?(::Mongoid::Document)
      is_virtus_model = owner_class.respond_to?(:attribute_set) # FIXME: is there a better way to check for virtus?

      temp_class.class_eval do
        include ::Mongoid::Document if is_mongoid_document
        include Virtus.model if is_virtus_model
        instance_eval(&block)
      end

      # setup attributes for :attr_accessor names
      excluded_attr_accessor_names = %i(validation_context _index before_callback_halted)
      (temp_class.attr_accessor_names - excluded_attr_accessor_names).each do |name|
        next if attribute_set.map(&:name).include?(name.to_sym)
        attribute name
      end

      # setup attributes for Mongoid fields
      if is_mongoid_document
        temp_class.fields.except(*%w(_id)).each do |name, field|
          next if attribute_set.map(&:name).include?(name.to_sym)
          attribute name, field.type
        end
      end

      # setup attributes for Virtus attributes
      if is_virtus_model
        temp_class.attribute_set.each do |att|
          next if attribute_set.map(&:name).include?(att.name.to_sym)
          attribute att.name, att.type
        end
      end

      owner_class.class_eval(&block)
    end

    def initialize(model, attrs = {})
      self.model = model
      super attributes_from_model.merge(attrs)
    end

    def update_model!(options = {})
      return unless model.present?
      return unless valid? || options[:skip_validations] == true
      attributes.except(:id).each do |name, value|
        model.send("#{name}=", value) if model.respond_to?(name)
      end
    end

    def to_hash(attrs = {})
      return unless model.present?
      key = model.respond_to?(:model_name) ? model.model_name.singular : model.class.to_s.underscore
      value = super()
      value = value.merge(id: model.id) if model.respond_to?(:id)
      value = value.merge(attrs)
      { key => value }
    end

    def cache_key
      attributes.values.flatten.map(&:to_s).reject(&:blank?).join('/')
    end

    private

    def attributes_from_model
      self.class.attribute_names.each_with_object({}) do |name, res|
        res[name] = model.send(name) if model.respond_to?(name)
        res
      end
    end
  end
end
