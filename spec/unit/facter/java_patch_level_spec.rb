require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe "java_patch_level" do
    context "if java is installed" do
      context 'returns java patch version extracted from java_version fact' do
        before :each do
          allow(Facter.fact(:java_version)).to receive(:value).and_return("1.7.0_71")
        end
        it do
          Facter.fact(:java_patch_level).value.should == "71"
        end
      end
    end

    context "if java is installed" do
      context 'returns java patch version extracted from java_version fact' do
        before :each do
          allow(Facter.fact(:java_version)).to receive(:value).and_return(nil)
        end
        it do
          Facter.fact(:java_patch_level).value.should == "JAVA_NOT_INSTALLED"
        end
      end
    end
  end
end