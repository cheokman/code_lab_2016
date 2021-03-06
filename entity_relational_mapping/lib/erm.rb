require 'descendants_tracker'

require 'erm/configuration'
require 'erm/options'
require 'erm/model'
require 'erm/attribute_set'
require 'erm/type_lookup'
require 'erm/attribute'
require 'erm/boolean'
require 'erm/attribute/builder'

module ERM
  Undefined = Object.new.freeze

  def self.config(&block)
    yield configuration if block_given?
    configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.register_model(klass)
    models.push(klass) unless models.include?(klass)
  end

  def self.models
    @models ||= []
  end  
end

