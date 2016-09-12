require 'spec_helper'

describe ERM::AttributeSet do
  describe "#create" do
    context "when include as module" do
      let(:user) do
        Class.new {
          extend ERM::AttributeSet.create(self)
        }
      end
        
      before(:each) do
      end

      it "is descendant of module" do
        expect(described_class.ancestors).to include(Module)
      end
    end
  end
end