require 'spec_helper'

describe "java" do
  let(:facts) { default_test_facts }
  let(:params) {
    {
      :update_version => '65',
      :minor_version => 'b17',
    }
  }

  it do
    should contain_class('boxen::config')
    should contain_class('wget')

    should contain_exec('download jdk 65')

    should contain_package('jdk 65')

    should contain_file('/test/boxen/bin/java').with({
      :source  => 'puppet:///modules/java/java.sh',
      :mode    => '0755'
    })
  end

  context 'fails when java version has Yosemite relevant bug' do
    let(:facts) { default_test_facts.merge({ :macosx_productversion_major => '10.10' }) }
    let(:params) {
      {
        :update_version => '65',
      }
    }
    it do
      expect {
        should contain_class('java')
      }.to raise_error(/Yosemite Requires Java 7 with a patch level >= 71 \(Bug JDK\-8027686\)/)
    end
  end
end
