module Axle
  module Serializer
    extend self
    REGISTERED_FORMATS = {}

    def self.extended(descendant)
      descendant.extend ClassMethods
      descendant.instance_variable_set("@format", :json)
    end

    def register_format(format, serializer, deserializer)
      REGISTERED_FORMATS[format] = [serializer, deserializer]
    end

    def register_formats
      REGISTERED_FORMATS
    end
    
    register_format(:marshal, lambda{|v| [Marshal.dump(v)].pack('m')},
      lambda do |v|
        begin
          Marshal.load(v.unpack('m')[0])
        rescue => e
          begin
            # Backwards compatibility for unpacked marshal output.
            Marshal.load(v)
          rescue
            raise e
          end
        end
      end)

    register_format(:yaml, lambda{|v| v.to_yaml}, lambda{|v| YAML.load(v)})
    register_format(:json, lambda{|v| v.to_json}, lambda{|v| JSON.parse(v)})

    module ClassMethods
      attr_reader :serializer, :deserializer
      attr_accessor :format

      def serialize_value(value)
        serializer.call(value)
      end

      def deserialize_value(value)
        deserializer.call(value)
      end

      def serializer
        serializer, deserializer = register_formats[@format]
        serializer
      end

      def deserializer
        serializer, deserializer = register_formats[@format]
        deserializer
      end
    end
  end
end