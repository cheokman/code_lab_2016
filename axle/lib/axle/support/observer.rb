module Axle
  module Observer
    def self.included(descendant)
      descendant.instance_variable_set('@observer_set', {})
      descendant.instance_variable_set('@observers', [])
      descendant.extend(ClassMethods)
    end
      
    module ClassMethods
      def add_observer(name, *obs)
        raise ObserverSetNameError if name.nil?
        get_observers(name)
        obs.each do |o|
          raise ObserverTypeError unless o.is_a? Processor
          @observers.push o
        end
      end

     private

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