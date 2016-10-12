module Axle
  module Messages
    module RequiredFields
      def self.extended(descendant)
        descendant.extend ClassMethods
      end

      module ClassMethods
        def inherited(descendant)
          descendant.require_fields *required_fields 
        end

        def require_fields(*new_fields)
          add_require_fields(new_fields)
          new_fields.each { |option| define_field_method(option) }
          self
        end

        def required_fields
          @required_fields ||= []
        end

        private

        def define_field_method(option)
          
        end

        def define_field_reader(method_name)
          
        end

        def define_field_writer(method_name)
          
        end

        def validate(data)
          required_fields.each do |f|
            raise Axle::Errors::MessageMissingRequiredFieldError unless data.has_key?(f)
          end
          true
        end

        def add_require_fields(new_fields)
          required_fields.concat(new_fields)
          self
        end
      end
    end
  end
end