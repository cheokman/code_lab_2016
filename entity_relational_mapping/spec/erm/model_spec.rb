require 'spec_helper'

describe ERM::Model do
  let(:user) do
    Class.new do
      include ERM::Model
    end
  end
  describe "#attribute" do
    it "has attribute class method" do
      expect(user).to respond_to(:attribute).with(3).arguments
    end
  end
end