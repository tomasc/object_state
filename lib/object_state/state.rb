require 'active_model'
require 'virtus'

module ObjectState
  class State
    include ActiveModel::Model
    include ActiveSupport::Rescuable
    include Virtus.model(nullify_blank: true)

    attr_accessor :model

    validates :model, presence: true

    def self.attribute_names
      attribute_set.map(&:name)
    end

    def self.setup_attributes(&block)
      # TODO: if original is Mongoid
      # TODO: if original is Virtus
      # if original is PoRo
      temp_class = Class.new(Object)
      default_public_methods = temp_class.new.public_methods
      temp_class.class_eval { instance_eval(&block) }
      (temp_class.new.public_methods - default_public_methods).reject { |name| name.to_s.end_with?('=') }.each do |name|
        attribute name, String
      end

      instance_eval(&block)
    end

    def initialize(model, attrs = {})
      self.model = model
      super attributes_from_model.merge(attrs)
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
