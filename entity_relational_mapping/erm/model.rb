module ERM
  module Model
    
    def self.included(base)
      base.extend ClassMethods
      base.class_eval { include InstanceMethods }
      base.class_eval { include InstanceMethods::Constructor }
      ERM.register_model(base)
    end

    module InstanceMethods
      module Constructor
        def initialize(attributes = nil)
          attribute_set.set(self, attributes) if attributes
        end
      end
    end

    module ClassMethods
      def attribute(name, type = nil, options = {})
        assert_valid_name(name)
        attribute_set << Attribute.build(type, options.merge(:name => name))
        self
      end

      def assert_valid_name(name)
        if instance_methods.include?(:attribute_set) && name.to_sym == :attribute_set
          raise ArgumentError, "#{name.inspect} is not allowed as an attribute name"
        end
      end

    end
  end
end