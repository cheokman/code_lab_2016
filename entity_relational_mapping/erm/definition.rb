module ERM
  class Definition
    TYPE_MAPPINGS = {
      boolean: ERM::Boolean,
      symbol: Symbol,
      integer: Integer,
      float: Float,
      big_decimal: Bignum,
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

    attr_reader :name, :type, :flags, :options
    attr_accessor :capacity, :value

    #def_delegators :type, :box_pack, :box_unpack

    def initialize(name, options={})
      @name = name
      @options = options
      @type = TYPE_MAPPINGS.fetch(options[:type], Object)
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
end