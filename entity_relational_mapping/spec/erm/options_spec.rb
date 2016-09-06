require 'spec_helper'

describe ERM::Options do
  let(:klass) do 
    Class.new {extend ERM::Options, DescendantsTracker }
  end

  let(:opt_klass) do
    klass.tap do 
      klass.send(:accept_options, :first_opt)
    end
  end

  let(:val_opt_klass) {opt_klass.tap {opt_klass.send(:first_opt, true); opt_klass.send(:second_opt, 1)}}
  
  describe ".extend" do
    context "when no any accept_options config" do
      it "has empty options hash" do
        expect(klass.options).to be_kind_of(Hash)
      end

      it "has empty accept_options array" do
        expect(klass.accepted_options).to be_empty
      end

      it "has respond_to accept_options class methods" do
        expect(klass).to respond_to(:accept_options)
      end
    end
  end

  describe ".accept_options" do
    context "when accept_options config without value" do
      it "has options hash with nil value" do
        pending
        expect(opt_klass.options).to have_key(:first_opt)
        expect(opt_klass.options).to have_key(:second_opt)
      end
    end
  end
end