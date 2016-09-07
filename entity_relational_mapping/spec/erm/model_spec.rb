require 'spec_helper'

describe ERM::Model do
  let(:user) do
    Class.new do
      include ERM::Model
    end
  end
  describe "class methods" do
    it "has assert_valid_name class method" do
      expect(user.private_methods).to include(:assert_valid_name)
    end

    it "has attribute class method" do
      expect(user).to respond_to(:attribute).with(3).arguments
    end

    describe "#assert_valid_name" do
      it "accpet any name except attribute_set name" do
        expect {user.send(:assert_valid_name, 'attribute_set') }.to raise_error(ArgumentError)
        expect {user.send(:assert_valid_name, 'any_name') }.not_to raise_error
      end
    end

    describe "#attribute" do
      let(:attribute) do
        Class.new
      end
    end
  end
end