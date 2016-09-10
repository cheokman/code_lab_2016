module ERM
  class AttributeSet < Module
    include Enumerable

    def self.create(descendant)
      if descendant.respond_to?(:superclass) && descendant.superclass.respond_to?(:attribute_set)
        parent = descendant.superclass.public_send(:attribute_set)
      end
      descendant.instance_variable_set('@attribute_set', AttributeSet.new(parent))
    end

    def initialize(parent = nil, attributes = [])
      @parent     = parent
      @attributes = attributes.dup
      @mapping    = {}
      reset
    end

    def each
      return to_enum unless block_given?
      @mapping.each { |name, attribute| yield attribute if name.kind_of?(Symbol) }
      self
    end

    def merge(attributes)
      attributes.each { |attribute| self << attribute }
      self
    end

    def <<(attribute)
      self[attribute.name] = attribute
      attribute.define_accessor_methods(self) if attribute.finalized?
      self
    end

    def [](name)
      @mapping[name]
    end

    def []=(name, attribute)
      @attributes << attribute
      update_mapping(name, attribute)
    end

    def reset
      merge_attributes(@parent) if @parent
      merge_attributes(@attributes)
      self
    end


    def define_reader_method(attribute, method_name, visibility)
      define_method(method_name) { attribute.get(self) }
      send(visibility, method_name)
    end

    def define_writer_method(attribute, method_name, visibility)
      define_method(method_name) { |value| attribute.set(self, value) }
      send(visibility, method_name)
    end

    def get(object)
      each_with_object({}) do |attribute, attributes|
        name = attribute.name
        attributes[name] = object.__send__(name) if attribute.public_reader?
      end
    end

    def set(object, attributes)
      attributes.each do |name, value|
        writer_name = "#{name}="
        if object.allowed_writer_methods.include?(writer_name)
          object.__send__(writer_name, value)
        end
      end
    end

    def set_defaults(object, filter = method(:skip_default?))
      each do |attribute|
        next if filter.call(object, attribute)
        attribute.set_default_value(object)
      end
    end

    private

    def skip_default?(object, attribute)
      attribute.lazy? || attribute.defined?(object)
    end

    def merge_attributes(attributes)
      attributes.each { |attribute| update_mapping(attribute.name, attribute) }
    end

    def update_mapping(name, attribute)
      @mapping[name] = @mapping[name.to_s.freeze] = attribute
    end

  end
end