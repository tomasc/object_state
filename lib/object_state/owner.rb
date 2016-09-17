require 'active_support/concern'

module ObjectState
  module Owner
    extend ActiveSupport::Concern

    module ClassMethods
      def object_state_class
        @@object_state_class
      end

      def object_state(options = {}, &block)
        @@object_state_class = Class.new(ObjectState::State)
        @@object_state_class.class_eval do
          setup_attributes do
            instance_eval(&block)
          end
        end

        instance_eval(&block)
      end
    end

    def object_state(attrs = {})
      self.class.object_state_class.new(self, attrs)
    end
  end
end
