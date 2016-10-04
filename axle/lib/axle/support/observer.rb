module Axle
  module Observer
    def self.included(descendant)
      descendant.instance_variable_set('@observer_set', {})
      descendant.instance_variable_set('@observers', [])
      descendant.extend(ClassMethods)
    end
      
    module ClassMethods
      def add_observer(name, *obs)
        named = check_name(name)
        get_observers(named)
        obs.each do |o|
          raise Axle::Errors::ObserverTypeError unless o.is_a? Processor
          @observers.push o
        end
      end

      private

      def check_name(name)
       raise Axle::Errors::ObserverSetNameError if name.nil?
       name
      end

      def notify_observers(context)
        @observer.dup.each do |o|
          begin
            o.process(context)
          rescue AxleErrors => e
            # TODO Axle Errors
          ensure
            next if e.nil?
            # Handle any unexpected Error Here
          end
        end 
      end

      def get_observers(name)
        @observers = @observer_set[name] ||= []
      end
    end
  end
end