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

    def initialize(model, attrs = {})
      self.model = model
      # super attributes_from_model.merge(attrs)
    end

    private

    # def attributes_from_model
    #   self.class.attribute_names.inject({}) do |res, name|
    #     res[name] = model.send(name) if model.respond_to?(name)
    #     res
    #   end
    # end
  end
end
