require 'active_support/concern'

module ObjectState
  module Owner
    extend ActiveSupport::Concern

    module ClassMethods
      def object_state_class
        @object_state_class ||= Class.new(ObjectState::State)
      end

      def object_state(options = {}, &block)
        cls = self
        @object_state_class = Class.new(ObjectState::State)
        @object_state_class.class_eval do
          setup_attributes cls, &block
        end
      end
    end

    def object_state(attrs = {})
      self.class.object_state_class.new(self, attrs)
    end
  end
end
