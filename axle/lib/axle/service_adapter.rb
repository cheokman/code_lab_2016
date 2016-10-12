module Axle
  module ServiceAdapter
    
    def self.included(descendant)
      descendant.extend ClassMethods
      descendant.class_eval{include InstanceMethods}
      descendant.instance_variable_set("@message_data", nil)
      descendant.instance_variable_set("@message",nil)
      descendant.instance_variable_set("@result",{})
      #descendant.instance_variable_set("@context", {})
    end
    
    module ClassMethods

      def self.extended(descendant)
        descendant.extend Processor
        descendant.extend Serializer
      end
      
      private

      def before_update
        parse_params
        build_message
        build_context
      end

      def update
        Axle.notify_observers(@context)
      end

      def after_update
        
      end

      def parse_params
        @message_data = deserialize_value(extract_message_data)
      end

      def extract_message_data
        {}
      end

      def build_message
        @message_data.merge!(request_info)
        @message = MessageFactory.build(@message_data)
      end

      def build_context
        @context[:message] = @message
      end

      def default_result
        result = { 
                     status: 200,
                       text: 'OK'
                   }
      end

      def respond_with_result
        default_result.merge({ 
          status: result[:status],
            text: serialize_value(result)
        })
      end
    end

    module InstanceMethods
    end
      
  end
end