require 'axle/support/options'
require 'axle/support/observer'
require 'axle/support/processor'

module Axle
  extend Observer
  extend Processor
  Undefined = Object.new.freeze

  def self.config
    @config ||= Configuration.new
  end

  def self.service_base_path
    @config.service_base_path
  end
end

if defined?(Rails)
  require 'axle/rails'
end

if defined?(Sinatra)
  require 'axle/sinatra'
end

require 'axle/configuration'
require 'axle/errors/axle_errors'
require 'axle/errors/observer_set_name_error'
require 'axle/errors/observer_type_error'