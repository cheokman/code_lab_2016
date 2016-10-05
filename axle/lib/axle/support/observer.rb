module Axle
  module Observer
    def self.included(descendant)
      descendant.instance_variable_set('@observer_set', {})
      descendant.instance_variable_set('@observers', [])
      descendant.extend(ClassMethods)
    end
      
    module ClassMethods
      def init_observer(name)
        get_observers(name)
      end

      def add_observer(name, *obs)
        get_observers(name)
        obs.each do |o|
          raise Axle::Errors::ObserverTypeError unless o.is_a? Processor
          @observers.push o
        end
      end

      alias :add_observers :add_observer

      private

      def check_name(name)
       raise Axle::Errors::ObserverSetNameError if name.nil?
       name
      end

      def notify_observers(context)
        @observers.dup.each do |o|
          begin
            o.process(context)
          rescue Axle::Errors::AxleErrors => e
            # TODO Axle Errors
            error_handler(context,e)
          ensure
            next if e.nil?
            # Handle any unexpected Error Here
            ensure_handler(context,e)
          end
        end 
      end

      def ensure_handler(context, error)
        
      end

      def error_handler(context, error)
        
      end

      def get_observers(name)
        named = check_name(name)
        @observers = @observer_set[name] ||= []
      end
    end
  end
end