require 'spec_helper'

describe Axle::Configuration::Options do
  before(:each) do
    @config = Class.new{
      extend Axle::Configuration::Options
    }
  end
  
  describe "#accepted_options" do
    context "empty accept options" do
      it "can return empty array of accepted_options" do
         expect(@config.accepted_options).to be_empty
      end

      it "can return empty hash of options" do
        expect(@config.options).to be_empty
      end
    end

    context "accept one option without value" do
      before(:each) do
        @config.accept_options :server
      end

      it "define access method" do
        expect(@config).to respond_to(:server)
        expect(@config).to respond_to(:server).with(1).argument
      end

      it "can save option in accepted_options" do
       expect(@config.accepted_options).to contain_exactly(:server)  
      end

      it "can return empty hash from options" do
       expect(@config.options).to be_empty
      end
    end

    context "accept one options with value" do
      before(:each) do
        @config.accept_options :server
        @config.server :sinatra
      end

      it "can return hash from options" do
       expect(@config.options).to be_eql({:server => :sinatra})
      end
    end

    context "accept over one options with value" do
      
      subject { 
        @config.accept_options :server, :port
        @config.server :sinatra 
      }
      

      it { is_expected.to respond_to(:server) }
      it { is_expected.to respond_to(:server).with(1).argument }
      it { is_expected.to respond_to(:port) }
      it { is_expected.to respond_to(:port).with(1).argument }

      it "can return define option" do
        expect(subject.accepted_options).to contain_exactly(:server, :port)
      end

      it "can return hash for options define value" do
        expect(subject.options).to be_eql({:server => :sinatra})
      end

    end
  end
end