require 'bundler/setup'

require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'

require 'object_state'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# ---------------------------------------------------------------------

class MyDoc
  include ObjectState::Owner

  object_state do
    attr_accessor :current_date
  end

  def initialize(current_date)
    self.current_date = current_date
  end
end
