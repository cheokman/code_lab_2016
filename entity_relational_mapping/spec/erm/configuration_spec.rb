require 'spec_helper'

describe ERM::Configuration do
  let(:config) {described_class.new}
  context ".initialize" do
    it "has default finalize value" do
      expect(config.finalize).to be_truthy
    end
  end

  describe ".to_h" do
    it "has convert to hash" do
      expect(config.to_h).to eq({finalize: true})
    end
  end
end