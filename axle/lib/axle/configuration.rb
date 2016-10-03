require 'axle/configuration/options'

module Axle
  class Configuration
    extend Options

    accept_options :base_path, :server, :port

    base_paht '/'
    
    def initialize(options={})
      yield self if block_given?
    end

    def to_h
      options.freeze
    end
  end
end