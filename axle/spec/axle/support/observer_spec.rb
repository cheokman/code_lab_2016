require 'spec_helper'

describe Axle::Observer do
  before(:each) do
    @owner = Class.new{
      include Axle::Observer
    }

    @ob1 = Class.new {
      extend Axle::Processor
    }

    @ob2 = Class.new {
      extend Axle::Processor
    }
  end

  describe "#included" do
    context "class methods" do
    subject {
      @owner
    }
      it {is_expected.to respond_to(:add_observer)}
    end

    context "class instane variables" do
      subject {
        @owner.instance_variables
      }
    
      it {is_expected.to include(:@observer_set)}
      it {is_expected.to include(:@observers)}

      context "class instance variables @observer_set" do
        subject {
          @owner.instance_variable_get(:@observer_set)
        }

        it {is_expected.to be_eql({})}
      end

      context "class instance variables @observers" do
        subject {
          @owner.instance_variable_get(:@observers)
        }

        it {is_expected.to be_eql([])}
      end
    end
  end

  describe "#get_observers by name" do
    context "initialized" do
      it "can return empty array" do
        expect(@owner.send(:get_observers, :game)).to be_empty
      end

      it "can have key in observer_set" do
        @owner.send(:get_observers, :game)
        expect(@owner.instance_variable_get(:@observer_set)).to have_key(:game)
      end

      it "can have empty array for key in observer_set" do
        @owner.send(:get_observers, :game)
        expect(@owner.instance_variable_get(:@observer_set)[:game]).to be_empty
      end

      it "can have emtpy observers" do
        @owner.send(:get_observers, :game)
        expect(@owner.instance_variable_get(:@observers)).to be_empty
      end

      it "can be same object of observers and value for key in observer_set" do
        @owner.send(:get_observers, :game)
        observers = @owner.instance_variable_get(:@observers)
        expect(@owner.instance_variable_get(:@observer_set)[:game]).to be_equal(observers)
      end
    end
  end
  
  describe "#check_name" do
    context "when name is nil" do
      it "can raise ObserverSetNameError" do
        expect {@owner.send(:check_name, nil)}.to raise_error(Axle::Errors::ObserverSetNameError)
      end
    end
  end

  describe "#add_observer" do
    before(:each) do
      allow(@owner).to receive(:get_observers) {{"game1" => [@ob1, @ob2]}}
    end
  end

end