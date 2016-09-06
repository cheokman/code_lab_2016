module ERM
  class Attribute
    class DefaultValue
      extend DescendantsTracker

      def self.build(*args)
        klass = descendants.detect { |descendant| descendant.handle?(*args) } || self
        klass.new(*args)
      end
    end
  end
end