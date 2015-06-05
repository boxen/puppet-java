require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
    allow(Facter::Util::Resolution).to receive(:exec).with(anything()).and_return(nil)
    allow(Facter.fact(:kernel)).to receive(:value).and_return("Darwin")
  }

  describe "java_version" do
    context 'returns java version when java present' do
      it do
        java_version_output = <<-EOS
java version "1.7.0_71"
Java(TM) SE Runtime Environment (build 1.7.0_71-b14)
Java HotSpot(TM) 64-Bit Server VM (build 24.71-b01, mixed mode)
        EOS
        allow(Facter::Util::Resolution).to receive(:exec).with("java -version 2>&1").
        and_return(java_version_output)
        Facter.fact(:java_version).value.should == "1.7.0_71"
      end
    end

    context 'returns nil when java not present' do
      it do
        java_version_output = "bash: java: command not found"
        allow(Facter::Util::Resolution).to receive(:exec).with("java -version 2>&1").
        and_return(java_version_output)
        Facter.fact(:java_version).value.should be_nil
      end
    end
  end
end
