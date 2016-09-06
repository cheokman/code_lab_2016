module ERM
  class Attribute
    module Accessor
      attr_reader :name

      attr_reader :instance_variable_name

      def self.extended(base)
        super
        name = base.options.fetch(:name).to_sym
        base.instance_variable_set('@name', name)
        base.instance_variable_set('@instance_variable_name', "@#{name}")
      end

      def defined?(instance)
        instance.instance_variable_defined?(instance_variable_name)
      end

      def get(instance)
        instance.instance_variable_get(instance_variable_name)
      end

      def set(instance, value)
        instance.instance_variable_set(instance_variable_name, value)
      end

      def set_default_value(instance)
        set(instance, default_value.call(instance, self))
      end
    end
  end
end