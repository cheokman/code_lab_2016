require 'json'
require 'yaml'
require 'axle/support'

module Axle
  extend Observer
  extend Processor

  Undefined = Object.new.freeze

  def self.config
    @config ||= Configuration.new
  end

  def self.service_base_path
    config.service_base_path
  end
end

if defined?(Rails)
  require 'axle/rails'
end

if defined?(Sinatra)
  require 'axle/sinatra'
end

require 'axle/configuration'
require 'axle/errors'
require 'axle/service_adapter'
require 'axle/sinatra'