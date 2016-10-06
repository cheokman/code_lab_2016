module Axle
  module Processor
    def self.extend(descendant)
      descendant.instance_variable_set('@context', {})
    end

    def start(context)
    end

    def finish(context)
    end

    def process(context)
      init
      pre_update
      update
      post_update
      finalize
    end

private
    def init(context)
      @context = context.deep_copy
    end

    def pre_update
    end

    def update
    end

    def post_update
    end

    def finalize
      @context
    end
  end
end