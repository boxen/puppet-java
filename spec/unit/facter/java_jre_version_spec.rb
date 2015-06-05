require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
    allow(Facter::Util::Resolution).to receive(:exec).with(anything()).and_return(nil)
    allow(Facter.fact(:kernel)).to receive(:value).and_return("Darwin")
  }

  describe "java_jre_version" do
    context 'returns java jre version when java jre present' do
      it do
        allow(File).to receive(:exist?).and_return(true)
        java_jre_version_output = <<-EOS
java version "1.7.0_71"
Java(TM) SE Runtime Environment (build 1.7.0_71-b14)
Java HotSpot(TM) 64-Bit Server VM (build 24.71-b01, mixed mode)
        EOS
        allow(Facter::Util::Resolution).to receive(:exec).with("'/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java' -version 2>&1").
        and_return(java_jre_version_output)
        Facter.fact(:java_jre_version).value.should == "1.7.0_71"
      end
    end

    context 'returns nil when java jre not present' do
      it do
        allow(File).to receive(:exist?).and_return(false)
        java_jre_version_output = "bash: /Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java: No such file or directory"
        allow(Facter::Util::Resolution).to receive(:exec).with("'/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java' -version 2>&1").
        and_return(java_jre_version_output)
        Facter.fact(:java_jre_version).value.should be_nil
      end
    end
  end
end
