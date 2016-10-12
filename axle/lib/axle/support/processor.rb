module Axle
  module Processor
    def self.extended(descendant)
      descendant.instance_variable_set("@context", {})
    end

    def start(context)
    end

    def finish(context)
    end

    def process(context)
      init
      before_update
      update
      after_update
      finalize
    end

private
    def init(context)
      @context = context.deep_copy
    end

    def before_update
    end

    def update
    end

    def after_update
    end

    def finalize
      @context
    end
  end
end