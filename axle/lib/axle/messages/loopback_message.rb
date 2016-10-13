module Axle
  module Messages
    class LoopbackMessage < Message
      def initialize(data, options={})
        super('loopback', data, options)
      end
    end
  end
end