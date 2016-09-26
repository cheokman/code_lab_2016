require 'spec_helper'

describe ERM::Definition do
  describe "#new" do
    context "default value" do
      before(:each) do
        @defined = described_class.new(:a)
      end
      
      it "has default standard flag" do
        expect(@defined.flags).to be_eql(ERM::Definition::VISIBILITY_MAPPINGS[:standard])
      end

      it "has defaut 0 capacity " do
        expect(@defined.capacity).to be_eql(0)
      end

      it "has empty hash options" do
        expect(@defined.options).to be_eql({})
      end

      it "has nil value" do
        expect(@defined.value).to be_nil
      end
    end

    context "when with undefined type" do
      before(:each) do
        @defined = described_class.new(:a)
      end

      it "has a Object primitive" do
        expect(@defined.primitive).to be_eql(Object)
      end  
    end

    context "when with define type" do
      it "support :boolean" do
        @defined = described_class.new(:boolean)
        expect(@defined.primitive).to be_eql(ERM::Boolean)
      end

      it "support :symbol" do
        @defined = described_class.new(:symbol)
        expect(@defined.primitive).to be_eql(Symbol)
      end

      it "support :integer" do
        @defined = described_class.new(:integer)
        expect(@defined.primitive).to be_eql(Integer)
      end
      it "support :float" do
        @defined = described_class.new(:float)
        expect(@defined.primitive).to be_eql(Float)
      end

      it "support :big_decimal" do
        @defined = described_class.new(:big_decimal)
        expect(@defined.primitive).to be_eql(Bignum)
      end

      it "support :string" do
        @defined = described_class.new(:string)
        expect(@defined.primitive).to be_eql(String)
      end

      it "support :time" do
        @defined = described_class.new(:time)
        expect(@defined.primitive).to be_eql(Time)
      end

      it "support :date" do
        @defined = described_class.new(:date)
        expect(@defined.primitive).to be_eql(Date)
      end

      it "support :date_time" do
        @defined = described_class.new(:date_time)
        expect(@defined.primitive).to be_eql(DateTime)
      end
    end

    context "when define standard flags " do
      before(:each) do
        @defined = described_class.new(:a, flags: :standard)
      end

      it "can't hidden" do
        expect(@defined.hidden?).to be_falsy
        expect(@defined.visible?).to be_truthy
      end

      it "can store" do
        expect(@defined.storable?).to be_truthy 
      end
    end

    context "when define hidden flags " do
      before(:each) do
        @defined = described_class.new(:a, flags: :hidden)
      end

      it "can hidden" do
        expect(@defined.hidden?).to be_truthy
        expect(@defined.visible?).to be_falsy
      end

      it "can store" do
        expect(@defined.storable?).to be_truthy 
      end
    end

    context "when define volatile flags " do
      before(:each) do
        @defined = described_class.new(:a, flags: :volatile)
      end

      it "can hidden" do
        expect(@defined.hidden?).to be_falsy
        expect(@defined.visible?).to be_truthy
      end

      it "can store" do
        expect(@defined.storable?).to be_falsy 
      end
    end
  end

end