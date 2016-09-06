module ERM
  class Attribute
    module LazyDefault
      def get(instance)
        if instance.instance_variable_defined?(instance_variable_name)
          super
        else
          set_default_value(instance)
        end
      end
    end
  end
end
