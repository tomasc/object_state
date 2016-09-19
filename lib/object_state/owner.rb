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
        class_name = options.fetch(:class_name, nil)
        @object_state_class = class_name ? class_name.constantize : Class.new(ObjectState::State)
        @object_state_class.class_eval do
          setup_attributes cls, &block
        end

        if instance_methods.include?(:cache_key) && options.fetch(:merge_cache_key, true)
          define_method :cache_key do |*args|
            return super(*args) unless object_state
            [super(*args), object_state.cache_key].reject(&:blank?).join('/')
          end
        end
      end
    end

    def object_state(attrs = {})
      self.class.object_state_class.new(self, attrs)
    end

    def to_state_hash(attrs = {})
      object_state(attrs).try(:to_hash)
    end

    def assign_attributes_from_state_hash(attrs)
      key = respond_to?(:model_name) ? model_name.singular : self.class.to_s.underscore
      return unless model_attrs = attrs.stringify_keys[key]
      model_id = model_attrs.stringify_keys['id'] || model_attrs.stringify_keys['_id']
      return if respond_to?(:id) && model_id.to_s != id.to_s
      object_state(model_attrs.except(*%i(_id id))).try(:update_model!)
    end
  end
end
