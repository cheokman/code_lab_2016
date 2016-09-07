$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'erm'
require 'rspec'

RSpec.configure do |config|
  config.before(:each) do
    ERM.instance_variable_set(:@models, [])
  end
end