module ERM
  class Definition
    TYPE_MAPPINGS = {
      boolean: ERM::Boolean,
      symbol: Symbol,
      integer: Integer,
      float: Float,
      big_decimal: Bignum, # need to check with Integer feature with ruby 3.x
      string: String,
      time: Time,
      date: Date,
      date_time: DateTime
    }

    VISIBILITY_MAPPINGS = {
      standard: 0,
      hidden: 1 << 0,
      volatile: 1 << 1
    }

    attr_reader :type, :primitive, :flags, :options
    attr_accessor :capacity, :value

    #def_delegators :type, :box_pack, :box_unpack

    def initialize(type, options={})
      @type = type
      @options = options
      @primitive = TYPE_MAPPINGS.fetch(@type, Object)
      @flags = VISIBILITY_MAPPINGS.fetch(options[:flags], VISIBILITY_MAPPINGS[:standard])
      @capacity = 0
    end
    
    def type
      @type
    end

    def hidden?
      (@flags & VISIBILITY_MAPPINGS[:hidden]) == VISIBILITY_MAPPINGS[:hidden]
    end

    def visible?
      (@flags & VISIBILITY_MAPPINGS[:hidden]) == 0
    end

    def storable?
      (@flags & VISIBILITY_MAPPINGS[:volatile]) == 0
    end
  end

  class Attribute
    class Builder
      attr_reader :attribute, :options, :definition, :klass, :type

      def self.call(type, options={})
        definition = Definition.new(type, options)

        new(definition, options).attribute
      end

      def self.determine_type(klass, default=nil)
        type = Attribute.determine_type(klass)
        type || default
      end

      def initialize(definition, options)
        @definition = definition

        initialize_class
        initialize_type
        initialize_options(options)
        initialize_default_value
        initialize_attribute
      end

      def initialize_class
        @klass = self.class.determine_type(definition.primitive, Attribute)
      end

      def initialize_type
        @type = klass.build_type(definition)
      end

      def initialize_options(options)
        @options = klass.options.merge(options)
        klass.merge_options!(type, @options)
        determine_visibility
      end

      def initialize_default_value
        options.update(:default_value => DefaultValue.build(options[:default]))
      end

      def initialize_attribute
        @attribute = klass.new(type, options)

        @attribute.extend(Accessor)    if options[:name]
        @attribute.extend(LazyDefault) if options[:lazy]
      end

      def determine_visibility
        default_accessor  = options.fetch(:accessor)
        reader_visibility = options.fetch(:reader, default_accessor)
        writer_visibility = options.fetch(:writer, default_accessor)
        options.update(:reader => reader_visibility, :writer => writer_visibility)
      end


    end
  end
end