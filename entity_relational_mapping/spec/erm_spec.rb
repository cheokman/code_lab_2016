require 'spec_helper'

 describe ERM do
   context "when using models registry from config" do
     it "has model registry" do
      expect(described_class.models).to be_a(Array)
      expect(described_class.models).to be_empty
     end
   end
 end 