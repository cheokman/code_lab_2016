module Axle
  module ServiceAdapter
    extend Processor
    extend Serializer

    def self.included(descendant)
      descendant.extend ClassMethods
      descendant.class_eval{include InstanceMethods}
    end
    
    module ClassMethods
      private

      def before_update
        default_result
        parse_params
      end

      def update
        
      end

      def after_update
        
      end

      def parse_params
        
      end

      def default_result
        @result = { 
                     status: 200,
                       text: 'OK'
                   }
      end

      def respond_with_result(result)
        { 
          status: result[:status],
          text: result.to_json
        }
      end
    end

    module InstanceMethods
    end
      
  end
end