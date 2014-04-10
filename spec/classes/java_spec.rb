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
    should include_class('boxen::config')

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
      :mode    => '0755',
      :require => 'Package[java]'
    })

    should contain_file("/Library/Java/JavaVirtualMachines/jdk1.7.0_42.jdk/Contents/Info.plist").with({
      :owner   => 'root',
      :group   => 'wheel',
      :mode    => '0664',
      :require => 'Package[java]'
    }).with_content(/<string>JNI<\/string>/).with_content(/<string>BundledApp<\/string>/).with_content(/<string>CommandLine<\/string>/)
  end
end
