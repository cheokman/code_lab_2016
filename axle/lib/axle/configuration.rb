module Axle
  class Configuration
    extend Options

    attr_accessor :service_base_path

    attr_accessor :serializer

    def initialize(options={})
      @service_base_path = options.fetch(:service_base_path, '/')
      @serializer = options.fetch(:serializer, :json)
      yield self if block_given?
    end

    def to_h
      self.class.options.freeze
    end
  end
end