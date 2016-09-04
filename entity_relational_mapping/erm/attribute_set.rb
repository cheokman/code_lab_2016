module ERM
  class AttributeSet
    include Enumerable

    def initialize(parent = nil, attributes = [])
      @parent = parent
      @attributes = attributes.dup
      @mapping      = {}
      reset
    end

    def each
      return to_enum unless block_given?
      @index.each { |name, attribute| yield attribute if name.kind_of?(Symbol) }
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


  end
end