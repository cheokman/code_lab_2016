module Axle
  class Configuration
    extend Options

    accept_options :server, :port

    def initialize(options={})
      yield self if block_given?
    end

    def to_h
      options.freeze
    end
  end
end