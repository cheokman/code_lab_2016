require 'date'

module Axle
  module Messages
    class Message
      extend Messages::RequiredFields
      
      require_fields :host, :ip, :type
      attr_reader :host, :ip, :type, :timestamp

      def initialize(type, data, options={})
        validate(data)
        @type = type
        @host = data['host']
        @ip = data['ip']
        @timestamp = get_timestamp
      end

      private
      def validate(data)
        self.class.validate(data)
      end

      def get_timestamp
        (Time.now.to_f * 1000).to_i
      end
    end
  end
end