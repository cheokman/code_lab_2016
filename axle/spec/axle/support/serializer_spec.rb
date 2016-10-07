require 'spec_helper'

describe Axle::Serializer do
  before(:each) do
    @instance = Class.new {
      extend Axle::Serializer
    }
  end

  describe "#included" do
    subject {
      @instance
    }
    it {is_expected.to respond_to(:register_format)}

    it {is_expected.to respond_to(:register_formats)}

    it {is_expected.to respond_to(:serialize_value)}

    it {is_expected.to respond_to(:deserialize_value)}

    it "should define format instance variable" do
      expect(@instance.instance_variables).to include(:@format)
    end

    it "should set :json as default format instance variable" do
      expect(@instance.format).to be_eql(:json)
    end
  end

  describe "#register_format" do
    before(:each) do
        @new_format = :fake
        @fake_serializer = lambda{ |v| "serialize #{v}" }
        @fake_deserializer = lambda{ |v| "deserialize #{v}" }
        @instance.register_format @new_format, @fake_serializer, @fake_deserializer 
      end

    context "when default" do
      it "should register :marshal format" do
        expect(@instance.register_formats).to have_key(:marshal)
      end

      it "should register :yaml format" do
        expect(@instance.register_formats).to have_key(:yaml)
      end

      it "should register :json format" do
        expect(@instance.register_formats).to have_key(:json)
      end
    end

    context "when register new format" do
      it "should regitser new :fake format" do
        expect(@instance.register_formats).to have_key(@new_format)
      end

      it "can serialize by serializer.call" do
        @instance.format = @new_format
        expect(@instance.serializer.call("data")).to be_eql @fake_serializer.call("data")
      end

      it "can deserialize by deserializer.call" do
        @instance.format = @new_format
        expect(@instance.deserializer.call("data")).to be_eql @fake_deserializer.call("data")
      end
    end
  end
end