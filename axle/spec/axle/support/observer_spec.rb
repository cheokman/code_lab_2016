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

    @new_ob1 = Class.new {
      extend Axle::Processor
    }

    @new_ob2 = Class.new {
      extend Axle::Processor
    }

    @error_ob1 = Class.new {
      extend Axle::Processor

      def self.process
        raise Axle::Errors:AxleErrors
      end
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

      context "class instance variables @name" do
        subject {
          @owner.instance_variable_get(:@name)
        }

        it {is_expected.to be_eql(nil)}
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
      @owner.instance_variable_set(:@observer_set, {"game1" => [@ob1, @ob2]})
    end
    
    context "when observer is inherated from Processor" do
      it "can add new game2 without observers" do
        @owner.add_observer "game2"
        expect(@owner.instance_variable_get(:@observers)).to be_empty
      end

      it "can add new game2 observers" do
        @owner.add_observer "game2", @new_ob1, @new_ob2
        expect(@owner.instance_variable_get(:@observers)).to be_eql([@new_ob1, @new_ob2])
      end

      it "can add existing game1 empty observer" do
        @owner.add_observer "game1"
        expect(@owner.instance_variable_get(:@observers)).to be_eql([@ob1, @ob2])
      end

      it "can add existing game1 some new observer" do
        @owner.add_observer "game1", @new_ob1
        expect(@owner.instance_variable_get(:@observers)).to be_eql([@ob1, @ob2, @new_ob1])
      end
    end
    context "when observer is not inherateed from Processor" do
      it "can reject" do
        expect {@owner.add_observer "game2", Class.new}.to raise_error(Axle::Errors::ObserverTypeError)
      end  
    end
  end

  describe "#notify_observers" do
    before(:each) do
      @owner.instance_variable_set(:@observer_set, {"game1" => [@ob1, @ob2]})
      @owner.init_observer("game1")
    end

    context "when no any error" do
      it "call first observer with context" do
        context = {context: "data"}
        expect(@ob1).to receive(:process).with(context)
        @owner.send(:notify_observers,context)
      end

      it "call following observer with returned context" do
        context = {context: "data"}
        allow(@ob1).to receive(:process).with(context).and_return(context)
        expect(@ob2).to receive(:process).with(context)
        @owner.send(:notify_observers,context)
      end

      it "ignore call ensure_processor" do
        context = {context: "data"}
        expect(@owner).to_not receive(:ensure_processor)#.with(context)
        @owner.send(:notify_observers, context)
      end

      it "ignore call error_processor" do
        context = {context: "data"}
        expect(@owner).to_not receive(:error_processor).with(context)
        @owner.send(:notify_observers, context)
      end
    end

    context "when error" do
      before(:each) do
        @context = {context: "data"}
        @error_context = {name: 'game1', error: "error"}
        @return_context = @context.merge(error: @error_context)
      end

      it "call error_processor" do
        allow(@owner).to receive(:error_context).and_return(@error_context)
        allow(@ob1).to receive(:process).and_raise(Axle::Errors::AxleErrors)
        expect(@owner).to receive(:error_processor).with(@return_context)
        @owner.send(:notify_observers, @context)
      end

      it "call ensure_processor" do
        allow(@owner).to receive(:error_context).and_return(@error_context)
        allow(@ob1).to receive(:process).and_raise(Axle::Errors::AxleErrors)
        expect(@owner).to receive(:ensure_processor).with(@return_context)
        @owner.send(:notify_observers, @context)
      end
    end
  end
end