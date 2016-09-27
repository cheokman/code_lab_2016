require 'spec_helper'

describe ERM::Attribute::Builder do
   describe "#determine_type" do
     context "attribute can't determine type" do
       let(:enu) do
         Class.new {
          include Enumerable
         }
       end

       let(:default) do
         Class.new
       end

       it "can return default" do
         allow(ERM::Attribute).to receive(:determine_type) {nil}
         expect(described_class.determine_type(enu,default)).to be_eql(default)
       end
     end
   end
   
   describe "initializer" do
     before(:each) do
        @str_defined = ERM::Definition.new(:string)
        @options = {}
        
     end

     describe "initialize class" do
      before(:each) do
        expect_any_instance_of(ERM::Attribute::Builder).to receive(:initialize_type) 
        expect_any_instance_of(ERM::Attribute::Builder).to receive(:initialize_options) 
        expect_any_instance_of(ERM::Attribute::Builder).to receive(:initialize_default_value) 
        expect_any_instance_of(ERM::Attribute::Builder).to receive(:initialize_attribute)
        @builder = described_class.new(@str_defined,@options)
      end

      it "can return Attribute when any defined attribute type" do
        expect(@builder.klass).to be_eql(ERM::Attribute)
      end
    end

    describe "initialize type" do
      before(:each) do
        allow(ERM::Attribute::Builder).to receive(:determine_type) {ERM::Attribute}
        expect_any_instance_of(ERM::Attribute::Builder).to receive(:initialize_options) 
        expect_any_instance_of(ERM::Attribute::Builder).to receive(:initialize_default_value) {}
        expect_any_instance_of(ERM::Attribute::Builder).to receive(:initialize_attribute) {}
        @builder = described_class.new(@str_defined,@options)
      end

      it "can assign type same as definition primitive type" do
        expect(@builder.type).to be_eql(@str_defined.primitive)
      end
    end

   end
end