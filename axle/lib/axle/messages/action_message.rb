module Axle
  module Messages
    class ActionMessage < Message
      require_fields :action
      def initialize(data, options={})
        super('action', data, options)
      end
    end
  end
end