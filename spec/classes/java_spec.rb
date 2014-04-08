require 'spec_helper'

describe "java" do
  let(:facts) { default_test_facts }
  let(:params) {
    {
      :base_download_url => 'https://downloads.test/java'
    }
  }

  it do
    should include_class('boxen::config')

    should contain_package('jre-8.dmg').with({
      :ensure   => 'present',
      :alias    => 'java-jre',
      :provider => 'pkgdmg',
      :source   => 'https://downloads.test/java/jre-8-macosx-x64.dmg'
    })

    should contain_package('jdk-8.dmg').with({
      :ensure   => 'present',
      :alias    => 'java',
      :provider => 'pkgdmg',
      :source   => 'https://downloads.test/java/jdk-8-macosx-x64.dmg'
    })

    should contain_file('/test/boxen/bin/java').with({
      :source  => 'puppet:///modules/java/java.sh',
      :mode    => '0755',
      :require => 'Package[java]'
    })
  end
end
