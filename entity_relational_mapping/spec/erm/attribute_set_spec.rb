require 'spec_helper'

describe ERM::AttributeSet do
  describe "#create" do
    describe "include as module" do
      let(:account) do
        Class.new {
          extend ERM::AttributeSet.create(self)

          def self.attribute_set
            @attribute_set
          end
        }
      end

      let(:user) do
        Class.new(account) do
          extend ERM::AttributeSet.create(self)
        end
      end

      let(:animal) do
        Class.new
      end

      let(:cat) do
        Class.new(animal) do
          extend ERM::AttributeSet.create(self)
        end
      end

      it "is descendant of module" do
        expect(described_class.ancestors).to include(Module)
      end

      context "when ancestor include attribute set" do
        it "and ancestor have attribute_set instance_variable_set" do
          expect(account.instance_variables).to include(:@attribute_set)
          expect(user.instance_variables).to include(:@attribute_set)
        end

        it "has attribute set's parent of ancestor's attribute set" do
          expect(user.instance_variable_get(:@attribute_set).instance_variable_get(:@parent)).to eq(account.instance_variable_get(:@attribute_set))
        end
      end

      context "when ancestor not include attribute set" do
        it "ancestor has not attribute_set instance_variable_set" do
          expect(animal.instance_variables).not_to include(:@attribute_set)
          expect(cat.instance_variables).to include(:@attribute_set)
        end

        it "has nil attribute set's parent" do
          expect(cat.instance_variable_get(:@attribute_set).instance_variable_get(:@parent)).to be_nil
        end
      end

      describe "intialize a attribute set" do
        let(:parent) do
          Class.new do
            include ERM::Model
          end
        end

        let(:user) do
          Class.new(parent) do
            include ERM::Model
          end
        end

        context "when parent parameter" do
          it "define parent variable" do
            expect(user.attribute_set.instance_variable_get(:@parent)).to be_eql(parent.attribute_set)
          end
        end
      end
    end
  end
end