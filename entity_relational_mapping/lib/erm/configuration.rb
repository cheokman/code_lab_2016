module ERM
  class Configuration

    attr_accessor :finalize

    def initialize(options={})
      @finalize        = options.fetch(:finalize, true)

      yield self if block_given?
    end

    def to_h
      {
        :finalize           => finalize,
       }.freeze
    end
  end
end