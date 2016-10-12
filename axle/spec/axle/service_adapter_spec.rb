require 'spec_helper'

describe Axle::ServiceAdapter do
  before(:each) do
    @message_data = {"data" => "test"}
    @service = Class.new {
      include Axle::ServiceAdapter
    }
  end

  describe "ancestor" do
    subject {
      @service
    }  

    it {is_expected.to be_kind_of(Axle::Processor)}
    it {is_expected.to be_kind_of(Axle::Serializer)}
  end
  
  describe "#included for instance variables" do
    subject {
      @service.instance_variables
    }

    it {is_expected.to include(:@message_data)}
    it {is_expected.to include(:@message)}
    it {is_expected.to include(:@result)}
    it {is_expected.to include(:@context)}
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
      expect(@service.instance_variable_get(:@message_data)).to be_eql(@message_data)    
    end
  end

end