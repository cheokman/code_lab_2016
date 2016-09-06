require 'spec_helper'

 describe ERM do
   context "when using models registry from config" do
     it "has model registry" do
      expect(described_class.models).to be_a(Array)
      expect(described_class.models).to be_empty
     end

     it "can registry same class once" do
       class A; end
       class B; end
       described_class.register_model(A)
       expect(described_class.models).to include(A)
       described_class.register_model(B)
       expect(described_class.models).to include(B)
       described_class.register_model(A)
       expect(described_class.models).to include(A)
     end

     it "has configuration instance" do
      expect(described_class.configuration).to be_instance_of(ERM::Configuration)
     end

     it "has accept config block" do
       described_class.config {|config| config.finalize = false}

       expect(described_class.configuration.finalize).to be_falsy

       described_class.config {|config| config.finalize = true}

       expect(described_class.configuration.finalize).to be_truthy

     end
   end
 end 