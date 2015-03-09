require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe "java_major_version" do
    context "if java is not installed" do
      context 'returns java major version extracted from java_version fact' do
        before :each do
          allow(Facter.fact(:java_version)).to receive(:value).and_return("1.7.0_71")
        end
        it do
          Facter.fact(:java_major_version).value.should == "7"
        end
      end
    end

    context "if java is not installed" do
      context 'returns nil' do
        before :each do
          allow(Facter.fact(:java_version)).to receive(:value).and_return(nil)
        end
        it do
          Facter.fact(:java_major_version).value.should == nil
        end
      end
    end
  end
end