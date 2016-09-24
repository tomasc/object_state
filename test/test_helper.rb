require 'bundler/setup'

require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'

require 'mongoid'
require 'object_state'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# ---------------------------------------------------------------------

class PoRoDoc
  include ObjectState::Owner

  object_state do
    attr_accessor :current_date
  end

  def initialize(current_date = nil)
    self.current_date = current_date
  end
end

class MongoidDoc
  include Mongoid::Document
  include ObjectState::Owner

  object_state do
    field :title, type: String
  end
end

class VirtusDoc
  include Virtus.model(nullify_blank: true)
  include ObjectState::Owner

  object_state do
    attribute :number, Integer
  end
end

class CustomStateOwner
  include Mongoid::Document
  include ObjectState::Owner

  class State < ObjectState::State
    attribute :title, String
    validates :title, presence: true

    def title
      return if super.nil?
      super.downcase
    end
  end

  object_state class_name: 'CustomStateOwner::State' do
    field :title, type: String
  end
end

class MultipleObjectStateOwner
  include Virtus.model(nullify_blank: true)
  include ObjectState::Owner

  object_state do
    attribute :number, Integer
  end

  object_state do
    attribute :title, String
  end
end
