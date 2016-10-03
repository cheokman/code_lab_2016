require 'axle/configuration'

module Axle
  Undefined = Object.new.freeze

  def self.config
    @config ||= Configuration.new
  end

  def self.base_path
    @config.base_path
  end
end

if defined?(Rails)
  require 'axle/rails'
end

if defined?(Sinatra)
  require 'axle/sinatra'
end