require 'spec_helper'

describe Axle::Configuration do
  describe "options" do
    context "defined options" do
      subject {
        described_class.new.instance_variables
      }
      
      it {is_expected.to include(:@service_base_path)}
      it {is_expected.to include(:@serializer)}
    end

    context "default value" do
      before(:each) do
        @instance = described_class.new
      end

      it "can define '/' as default value of service_base_path" do
        expect(@instance.service_base_path).to be_eql('/')
      end

      it "can define :json as default value of serializer" do
        expect(@instance.serializer).to be_eql(:json)
      end
    end
  end
end