require 'spec_helper'

describe ERM::TypeLookup do
  let(:str_defined) do
    ERM::Definition.new(:string)
  end

  let(:dup_str_defined) do
    ERM::Definition.new(:string)
  end

  let(:int_defined) do
    ERM::Definition.new(:integer)
  end

  before(:each) do
    @model = Class.new() {
      extend DescendantsTracker
      extend ERM::TypeLookup
    }
    @attribute = Class.new(ERM::Attribute)
  end
  context "cache lookup" do
    it "has cache empty hash variable @type_lookup_cache " do
      expect(@model.instance_variable_get(:@type_lookup_cache)).to be_eql({})
    end

    it "can cache class type according to class when first lookup" do
      allow(@model).to receive(:determine_type_and_cache) { String }
      expect(@model).to receive(:determine_type_and_cache)
      @model.determine_type(str_defined)
      cache = @model.instance_variable_get(:@type_lookup_cache)
      expect(cache).to have_key(str_defined)
      expect(cache[str_defined]).to be_eql(String)
    end

    it "can same class type with difference class object" do
      allow(@model).to receive(:determine_type_and_cache) { String }
      @model.determine_type(str_defined)
      @model.determine_type(dup_str_defined)
      cache = @model.instance_variable_get(:@type_lookup_cache)
      expect(cache).to have_key(str_defined)
      expect(cache).to have_key(dup_str_defined)
      expect(cache[str_defined]).to be_eql(String)
      expect(cache[dup_str_defined]).to be_eql(String)
    end

    it "can retrive from cache when same class is looked up" do
      allow(@model).to receive(:determine_type_and_cache) { String }
      @model.determine_type(str_defined)
      expect(@model).not_to receive(:determine_type_and_cache)
      @model.determine_type(str_defined)
    end

  end

  it "has primitive feature" do
    expect(@model.respond_to?(:primitive)).to be_truthy
  end

  it "need to implement primitive" do
    expect{@model.primitive}.to raise_error(NotImplementedError)
  end

  it "can determine type from primitive" do
    expect(@attribute.send(:determine_type_from_primitive, str_defined)).to be_eql(str_defined.primitive)
  end

end