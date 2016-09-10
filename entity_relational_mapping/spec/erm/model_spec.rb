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
      before(:each) do
        attribute = double("attribute", :name =>"a")
      end

      it "return instance when calling attribute" do
        attribute = double("attribute", :name =>"a")
        allow(ERM::Attribute).to receive(:build).and_return(attribute)
        allow_any_instance_of(ERM::AttributeSet).to receive(:<<).and_return(nil)
        expect(user.attribute("a")).to eq(user)
      end
    end

    describe "#allowed_writer_methods" do
      context "when public_instance_methods without any invalid_writer_methods" do
        before do
          allow(user).to receive(:allowed_methods).and_return(["a","b="])
        end

        it "return allow writer methods" do
          expect(user.allowed_writer_methods).to eq(["b="].to_set)
        end

        it "return frozen writer methods" do
          expect(user.allowed_writer_methods.frozen?).to be_truthy
        end
      end

      context "when public_instance_methods with any invalid_writer_methods" do
        before do
          allow(user).to receive(:allowed_methods).and_return(["a","b=","==","attributes="])
        end

        it "return allow writer methods without invalid_writer_methods" do
          expect(user.allowed_writer_methods).to eq(["b="].to_set)
        end
      end
    end
  end
end