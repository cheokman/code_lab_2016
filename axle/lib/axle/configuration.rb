module Axle
  class Configuration
    extend Options

    accept_options :service_base_path

    service_base_path '/'

    def initialize(options={})
      yield self if block_given?
    end

    
    def to_h
      self.class.options.freeze
    end
  end
end