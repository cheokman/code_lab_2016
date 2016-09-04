module ERM
  module Model
    
    def self.included(base)
      base.extend         ClassMethods
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
    end
  end
end