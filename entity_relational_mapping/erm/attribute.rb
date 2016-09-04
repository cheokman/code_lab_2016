module ERM
  class Attribute
    attr_reader :type, :options, :default_value

    def initialize(type, options)
      @type          = type
      @options       = options
      @default_value = options.fetch(:default_value)
    end

    def define_accessor_methods(attribute_set)
      attribute_set.define_reader_method(self, name,       options[:reader])
      attribute_set.define_writer_method(self, "#{name}=", options[:writer])
    end

  end
end