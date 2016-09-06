require 'spec_helper'

describe ERM do
  describe ".model" do
    it "has model registry" do
      expect(described_class.models).to be_a(Array)
      expect(described_class.models).to be_empty
    end
  end

  describe ".register_model" do
    it "can registry same class once" do
      class A; end
      class B; end
      described_class.register_model(A)
      expect(described_class.models).to include(A)
      described_class.register_model(B)
      expect(described_class.models).to include(B)
      described_class.register_model(A)
      expect(described_class.models.count(A)).to eq(1)
    end
  end

  describe ".configuration" do
    it "has configuration instance" do
      expect(described_class.configuration).to be_instance_of(ERM::Configuration)
    end
  end

  describe ".config" do
    context "when no block supplied" do
      it "returns the configuration singleton" do
        expect(described_class.config).to be(described_class.configuration)
      end
    end

    context "when a block is supplied" do
      before do
        described_class.config {|config| config.finalize = false}
      end

      after do
        described_class.config {|config| config.finalize = true}
      end

      it "has accept config block" do
        expect(described_class.config.finalize).to be_falsy
      end
    end
  end
end
