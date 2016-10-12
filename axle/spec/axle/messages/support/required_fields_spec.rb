require 'spec_helper'

describe Axle::Messages::RequiredFields do
  before(:each) do
    @new_fields = [:type, :host]
    @valid_data = {:type => 1, :host => 2}
    @invalid_data = {:type => 1, :hosts => 2}
    @action_fields = [:action]
    @fake = Class.new {
      extend Axle::Messages::RequiredFields
    }
    @message = Class.new {
      extend Axle::Messages::RequiredFields
      require_fields :type, :host
    }

    @action_message = Class.new(@message) {
      require_fields :action
    }
  end

  describe "base class extend" do
    context "when extend defined base methods" do
      subject {
        @fake
      }
      it {is_expected.to respond_to(:require_fields)}
      it {is_expected.to respond_to(:required_fields)}
    end
  end

  describe "#add_require_fields" do
    subject {
      @fake
    }

    it "has empty required_fields" do
      expect(subject.required_fields).to be_empty
    end

    it "can add new require fields" do
      subject.send(:add_require_fields, @new_fields) 
      expect(subject.required_fields).to be_eql(@new_fields) 
    end
  end

  describe "#validate" do
    subject {
      @message
    }

    it "can pass validation for valid data" do
      expect(subject.send(:validate, @valid_data)).to be_truthy
    end

    it "can raise error for invalid data" do
      expect{ subject.send(:validate, @invalid_data) }.to raise_error(Axle::Errors::MessageMissingRequiredFieldError)
    end

    describe "add more required fields" do
      it "can add field one by one" do
        subject.send(:add_require_fields, [:f1,:f2])
        expect(subject.required_fields).to be_eql(@new_fields + [:f1,:f2])
      end
    end
  end

  describe "instance fields accessor" do
    subject {
      @message.new
    }

    it {is_expected.to respond_to :type}
    it {is_expected.to respond_to :type=}
    it {is_expected.to respond_to :host}
    it {is_expected.to respond_to :host=}
  end

  describe "inherited class" do
    before(:each) do
      @child_valid_data = {:type => 1, :host => 2, :action => 3}
      @missing_parent_field_data = {:host => 2, :action => 3}
      @missing_field_data = {:type => 1, :host => 2}
    end

    context "when inherited extened class" do
      subject {
        @action_message
      }

      it "can inherite required field from parent class" do
       expect(@action_message.required_fields).to be_eql(@new_fields + @action_fields)
      end

      it "can validate all required fields" do
        expect(subject.send(:validate, @child_valid_data)).to be_truthy
      end

      it "can raise error when missing parent required fields" do
        expect{ subject.send(:validate, @missing_parent_field_data) }.to raise_error(Axle::Errors::MessageMissingRequiredFieldError)
      end

      it "can raise error when missing required fields" do
        expect{ subject.send(:validate, @missing_field_data) }.to raise_error(Axle::Errors::MessageMissingRequiredFieldError)
      end
    end
  end
end