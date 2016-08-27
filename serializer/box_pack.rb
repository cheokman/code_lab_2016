class Box < Hash
  CLASS_MAPPINGS = {
      static: 0,
      attribute: 1,
      dock: 2
    }

  TYPE_MAPPINGS = {
    boolean: Databox::Boolean,
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

  def []=(key, value)
    raise Error.new(name) if valid_key?(key)
    self[name.to_s] = value
  end

  def [](key)
    self[name.to_s]
  end

  def method_missing(method, *args)
    m = method.to_s
    key = m.gsub(/=$/,'')
    raise Error "Invalid key name" if valid_key?(key)
    m.match(/=$/) ? self.send("[#{key}]=", *args) : self[key]
  end

  def valid_key?(key)
    !key.match(/^_/).nil?
  end
end

class BoxPack
  class << self
    attr_reader :packer, :config
    def packer(opt=nil)
      @serializer ||= default_packer
      return @serializer if opt.nil?
      @serializer = opt
    end

    def default_packer
      :json
    end

    def instance
    end

    def pack
      instance.pack
    end

    def unpack
    end
  end

  def pack

  end

  def unpack
  end
end


