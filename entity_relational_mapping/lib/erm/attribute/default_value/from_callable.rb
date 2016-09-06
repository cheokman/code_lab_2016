module Virtus
  class Attribute
    class DefaultValue

      class FromCallable < DefaultValue

        def self.handle?(value)
          value.respond_to?(:call)
        end

        def call(*args)
          @value.call(*args)
        end

      end
    end
  end
end
