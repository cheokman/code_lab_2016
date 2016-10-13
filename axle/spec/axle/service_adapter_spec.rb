require 'spec_helper'

describe Axle::ServiceAdapter do
  before(:each) do
    @message_data = {"data" => "test"}
    @service_class = Class.new {
      include Axle::ServiceAdapter
    }
    @service = @service_class.new
  end

  describe "ancestor" do
    subject {
      @service_class
    }  

    it {is_expected.to be_kind_of(Axle::Serializer)}
  end
  
  describe "#parse_params" do
    it "can call extract_message_data" do
      allow(@service).to receive(:deserialize_value).and_return(@message_data)
      expect(@service).to receive(:extract_message_data)
      @service.send(:parse_params)
    end

    it "can call deserialize_value" do
      allow(@service).to receive(:extract_message_data).and_return(@message_data.to_json)
      expect(@service).to receive(:deserialize_value)
      @service.send(:parse_params)
    end

    it "can deserialize value" do
      allow(@service).to receive(:extract_message_data).and_return(@message_data.to_json)
      @service.send(:parse_params)
      expect(@service.message_data).to be_eql(@message_data)    
    end
  end

  describe "#build_message" do
    before(:each) do
      @request_info = {:host => "localhost", :ip => '1.1.1.1'}
      @message_factory = Axle::MessageFactory
    end

    it 'can merge request_info to message data' do
      @message = double()
      allow(@message_factory).to receive(:build).and_return(@message)
      allow(@service).to receive(:request_info).and_return(@request_info)
      @service.message_data = {}
      @service.send(:build_message)
      expect(@service.instance_variable_get(:@message_data)).to be_eql(@request_info)
    end
  end
end