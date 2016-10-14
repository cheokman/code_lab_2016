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
  
  describe ".parse_params" do
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

  describe ".build_message" do
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

  describe ".update_from_context" do
    before(:each) do
      @no_status_context = {}
      @error_context = {status: 400, error: "error occurred"}
      @no_response_context = {status: 200}
      @context = {status: 200, response: {message: 'hi'}}
    end

    context "no status" do
      before(:each) do
        @service.context = @no_status_context
        @service.process_result = @service.send(:default_process_result)
      end
      it "return nil" do
        expect(@service.send(:update_from_context)).to be_nil
      end

      it "does not update process_result" do
        expect(@service.process_result).to be_eql(@service.send(:default_process_result))        
      end
    end

    context "error" do
      before(:each) do
        @service.context = @error_context
        @service.process_result = @service.send(:default_process_result)
        @service.send(:update_from_context)
        @error_result = {status: @error_context[:status], text: @error_context[:error]}
      end

      it "return error process_result" do
        expect(@service.process_result).to be_eql(@error_result)
      end
    end

    context "no response" do
      before(:each) do
        @service.context = @no_response_context
        @service.process_result = @service.send(:default_process_result)
        @service.send(:update_from_context)
        @result = {status: @no_response_context[:status], text: 'Request is successfully carried out.'}
      end

      it "return request successful" do
        expect(@service.process_result).to be_eql(@result)
      end
    end

    context "normal" do
      before(:each) do
        @service.context = @context
        @service.process_result = @service.send(:default_process_result)
        @service.send(:update_from_context)
        @result = {status: @context[:status], text: @context[:response]}
      end

      it "return success and response" do
        expect(@service.process_result).to be_eql(@result)
      end
    end
  end
end