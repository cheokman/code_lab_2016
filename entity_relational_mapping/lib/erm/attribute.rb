module ERM
  class Attribute
    extend DescendantsTracker, Options, TypeLookup

    accept_options :visibility, :default, :as

    attr_reader :type, :options, :default_value

    def self.builder(type, options={})
      Builder.call(type, options)
    end

    def self.build_type(definition)
      definition.primitive
    end

    def self.merge_options!(*)
      # noop
    end

    def initialize(type, options)
      @type          = type
      @options       = options
      @default_value = options.fetch(:default_value)
    end

    def lazy?
      kind_of?(LazyDefault)
    end

    def define_accessor_methods(attribute_set)
      attribute_set.define_reader_method(self, name,       options[:reader])
      attribute_set.define_writer_method(self, "#{name}=", options[:writer])
    end

  end
end