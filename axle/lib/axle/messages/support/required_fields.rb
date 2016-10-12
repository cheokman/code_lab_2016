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

        def define_field_method(field_name)
          define_field_reader(field_name)
          define_field_writer(field_name)
        end

        def define_field_reader(field_name)
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{field_name}           # def default
              @#{field_name}            #   @default
            end                         # end
          RUBY
        end

        def define_field_writer(field_name)
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{field_name}=(value)           # def default=(value)
              @#{field_name} = value            #   @default = value
            end                                 # end
          RUBY
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