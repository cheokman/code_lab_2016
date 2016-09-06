module Virtus
  class Attribute
    class DefaultValue
      class FromSymbol < DefaultValue
        def self.handle?(value)
          value.is_a?(Symbol)
        end

        def call(instance, _)
          instance.respond_to?(@value, true) ? instance.send(@value) : @value
        end
      end
    end
  end
end
