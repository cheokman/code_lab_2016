require 'spec_helper'
require 'rack/test'

describe Axle::Service do
  include Rack::Test::Methods
  def app
    described_class.new
  end

  describe "#get /check" do
    context "when get /check" do
      before(:each) do
        get '/check'
      end
      it "can display OK" do
        expect(last_response.body).to include("OK")
      end

      it "receive status 200" do
        expect(last_response.status).to be_eql 200
      end
    end

    context "when get /check.json" do
      before(:each) do
        get '/check.json'
      end
      it "can display OK json" do
        expect(last_response.body).to include("json")
      end

      it "receive status 200" do
        expect(last_response.status).to be_eql 200
      end
    end

    context "when get /check?format=json" do
      before(:each) do
        get '/check?format=json'
      end
      it "can display OK json" do
        expect(last_response.body).to include("json")
      end

      it "receive status 200" do
        expect(last_response.status).to be_eql 200
      end
    end

    context "when get /check.yaml" do
      before(:each) do
        get '/check.yaml'
      end
      it "can display OK yaml" do
        expect(last_response.body).to include("yaml")
      end

      it "receive status 200" do
        expect(last_response.status).to be_eql 200
      end
    end

  end

  describe "#post /message/create" do
    context "when post /message/create" do
      before(:each) do
        @msg = {'msg' => {'type' => 'loopback'}.to_json}
      end

      it "can return 200" do
        @message = double()
        allow(Axle::MessageFactory).to receive(:build).and_return({data: 'message'})
        allow(Axle).to receive(:notify_observers).and_return({status: 200, response: @msg['msg']})
        post "/messages/create", @msg
        expect(last_response.body).to be_eql({status: 200, text: @msg['msg']}.to_json)
      end
    end
  end
end