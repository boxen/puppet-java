require 'spec_helper'

describe "java" do
  let(:facts) { default_test_facts }
  let(:params) {
    {
      :update_version => '42',
      :base_download_url => 'https://downloads.test/java'
    }
  }

  it do
    should contain_class('boxen::config')

    should contain_package('jre-7u42.dmg').with({
      :ensure   => 'present',
      :alias    => 'java-jre',
      :provider => 'pkgdmg',
      :source   => 'https://downloads.test/java/jre-7u42-macosx-x64.dmg'
    })

    should contain_package('jdk-7u42.dmg').with({
      :ensure   => 'present',
      :alias    => 'java',
      :provider => 'pkgdmg',
      :source   => 'https://downloads.test/java/jdk-7u42-macosx-x64.dmg'
    })

    should contain_file('/test/boxen/bin/java').with({
      :source  => 'puppet:///modules/java/java.sh',
      :mode    => '0755'
    })
  end

  context 'fails when java version has Yosemite relevant bug' do
    let(:facts) { default_test_facts.merge({ :macosx_productversion_major => '10.10' }) }
    let(:params) {
      {
        :update_version => '51',
      }
    }
    it do
      expect {
        should contain_class('java')
      }.to raise_error(/Yosemite Requires Java 7 with a patch level >= 71 \(Bug JDK\-8027686\)/)
    end
  end
end
