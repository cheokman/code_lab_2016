require 'spec_helper'

describe ERM::Options do
  let(:klass) do 
    Class.new { extend ERM::Options, DescendantsTracker }
  end

  let(:opt_klass) do
    Class.new do 
      extend ERM::Options, DescendantsTracker
      accept_options :first_opt, :second_opt
    end
  end

  let(:desc_opt_klass) do
    Class.new(opt_klass)
  end

  let(:val_opt_klass) do
    Class.new do 
      extend ERM::Options, DescendantsTracker
      accept_options :first_opt, :second_opt
      first_opt false
      second_opt 1
    end
  end

  let(:desc_val_opt_klass) do
    Class.new(val_opt_klass)
  end
  
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
      it "has empty options hash" do
        expect(opt_klass.options).to be_empty
      end

      it "has first_opt and second_opt in accepted_options array" do
        expect(opt_klass.accepted_options).to eq([:first_opt, :second_opt])
      end

      it "respond to first_opt and second_opt" do
        expect(opt_klass).to respond_to(:first_opt).with(1).argument
        expect(opt_klass).to respond_to(:second_opt).with(1).argument
      end

      it "can return nil when call options methods" do
        expect(opt_klass.first_opt).to be_nil
        expect(opt_klass.second_opt).to be_nil
      end

      it "has same accepted_options in descendant" do
        expect(desc_opt_klass.accepted_options).to eq(opt_klass.accepted_options)
      end
    end

    context "when accept_options config with value" do
      after do
        val_opt_klass.first_opt false
        val_opt_klass.second_opt 1
      end
      it "has options hash with values" do
        expect(val_opt_klass.options).to have_key(:first_opt)
        expect(val_opt_klass.options).to have_key(:second_opt)
        expect(val_opt_klass.options[:first_opt]).to eq(false)
        expect(val_opt_klass.options[:second_opt]).to eq(1)
      end

      it "can access options value with method" do
        expect(val_opt_klass.first_opt).to be_falsy
        expect(val_opt_klass.second_opt).to eq(1)

        val_opt_klass.first_opt true
        expect(val_opt_klass.first_opt).to be_truthy
        val_opt_klass.second_opt 2
        expect(val_opt_klass.second_opt).to eq(2)
      end


      it "can access options in descendant" do
        expect(desc_val_opt_klass.first_opt).to be_falsy
        expect(desc_val_opt_klass.second_opt).to eq(1)
      end
    end
  end
end