module ERM
  module Model
    
    def self.included(descendant)
      descendant.extend ClassMethods
      descendant.class_eval { include InstanceMethods }
      descendant.class_eval { include InstanceMethods::Constructor }
      ERM.register_model(descendant)
    end

    module InstanceMethods
      module Constructor
        def initialize(attributes = nil)
          attribute_set.set(self, attributes) if attributes
        end
      end

      def allowed_writer_methods
        self.class.allowed_writer_methods
      end

      def attribute_set
        self.class.attribute_set
      end
    end

    module ClassMethods
      WRITER_METHOD_REGEXP   = /=\z/.freeze
      INVALID_WRITER_METHODS = %w[ == != === []= attributes= ].to_set.freeze
      RESERVED_NAMES         = [:attributes].to_set.freeze

      def self.extended(descendant)
        super
        descendant.send(:include, AttributeSet.create(descendant))
      end
      private_class_method :extended

      def attribute(name, type = nil, options = {})
        assert_valid_name(name)
        attribute_set << Attribute.build(type, options.merge(:name => name))
        self
      end

      # def values(&block)
      #   private :attributes= if instance_methods.include?(:attributes=)
      #   yield
      #   include(::Equalizer.new(*attribute_set.map(&:name)))
      # end

      def allowed_writer_methods
        @allowed_writer_methods ||=
          begin
            allowed_writer_methods  = allowed_methods.grep(WRITER_METHOD_REGEXP).to_set
            allowed_writer_methods -= INVALID_WRITER_METHODS
            allowed_writer_methods.freeze
          end
      end

      def attribute_set
        @attribute_set
      end

      private

      def allowed_methods
        public_instance_methods.map(&:to_s)
      end

      def assert_valid_name(name)
        if instance_methods.include?(:attribute_set) && name.to_sym == :attribute_set
          raise ArgumentError, "#{name.inspect} is not allowed as an attribute name"
        end
      end

    end
  end
end