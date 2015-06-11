require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe "java_patch_level" do
    context 'returns java patch version extracted from java_version fact' do
      before :each do
        allow(Facter.fact(:java_version)).to receive(:value).and_return("1.7.0_71")
      end
      it do
        Facter.fact(:java_patch_level).value.should == "71"
      end
    end

    context "returns nil when java_version fact not present" do
      before :each do
        allow(Facter.fact(:java_version)).to receive(:value).and_return(nil)
      end
      it do
        Facter.fact(:java_patch_level).value.should be_nil
      end
    end
  end
end