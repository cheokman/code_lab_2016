module Axle
  class MessageFactory
    class << self

      def build(data, options={})
        validate(data)
      end

private
      def required_fields
        ["host", "ip", "type"]
      end

      def validate(data)
        required_fields.each do |f|
          raise Axle::Errors::MessageMissingRequestInfoError unless data.has_key?(f)
        end
      end
    end
    attr_reader :message, :message_data, :klass, :message_type
    def initialize(data, options)
      @message_data = data
      initialize_class
    end

    def initialize_class
      @klass = look_class
    end

    def initialize_message
      @message = klass.new(@message_data, options)
    end

    def lookup_class
      ::Object.const_get(message_type)
    end

    def message_type
      "Axel::Messages::#{@data['type']}Message"
    end
  end
end