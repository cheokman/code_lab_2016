require 'spec_helper'

describe Axle::Configuration do
  describe "accept_options" do
    subject {
      described_class
    }

    it { is_expected.to respond_to(:service_base_path) }

    context "#service_base_path" do
      before(:each) do
        described_class.service_base_path '/'
        @config = described_class.new
      end
      it "can have default value top path '/'" do
        expect(described_class.service_base_path).to be_eql('/')
      end

      it "can return in to_h with key service_base_path" do
        expect(@config.to_h).to have_key(:service_base_path)
      end

      it "can return value in to_h with key service_base_path" do
        expect(@config.to_h[:service_base_path]).to be_eql('/')
      end


      it "can config other value" do
        described_class.service_base_path "/base"
        expect(described_class.service_base_path).to be_eql("/base")
      end
    end
  end
end