require 'descendants_tracker'

module ERM
  Undefined = Object.new.freeze

  def self.config(&block)
    yield configuration if block_given?
    configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def register_model(klass)
    models.push(klass) unless models.include?(klass)
  end

  def models
    @models ||= []
  end  
end