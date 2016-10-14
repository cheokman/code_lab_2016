module Axle
  module ServiceAdapter
    
    def self.included(descendant)
      descendant.extend ClassMethods
      descendant.extend Serializer
      descendant.class_eval { include InstanceMethods }
    end
    
    module InstanceMethods
      attr_accessor :message, :message_data, :process_result, :context
      
      private
      def init
        @context = {}
        @message_data = {}
        @process_result = default_process_result
      end

      def before_update
        parse_params
        build_message
        build_context
      end

      def update
        @context = Axle.notify_observers(@context)
      end

      def process_message()
        begin
        init
        before_update
        update
        after_update
        final
      rescue Exception => e
        @context[:status] = 500
        @context[:error] = e.message
      end
      end

      def after_update
        update_from_context
      end

      def final
        @context
      end

      def parse_params
        @message_data = deserialize_value(extract_message_data)
      end

      def extract_message_data
        {}
      end

      def request_info
        {}
      end

      def build_message
        @message_data.merge!(request_info)
        @message = MessageFactory.build(@message_data)
      end

      def build_context
        @context[:message] = @message
      end

      def default_process_result
        { 
                     status: 200,
                       text: 'OK'
         }
      end

      def respond_with_result
        serialize_value(@process_result)
      end

      def update_from_context
        @process_result = default_process_result
        return if @context[:status].nil?
        @process_result[:status] = @context[:status]
        @process_result[:text]   = @context[:status] == 200 ?
                          (@context[:response] || 'Request is successfully carried out.') :
                          @context[:error]
        
      end

      def deserialize_value(value)
        self.class.deserialize_value(value)
      end

      def serialize_value(value)
        self.class.serialize_value(value)
      end
    end

    module ClassMethods
    end
      
  end
end