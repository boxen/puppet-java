require 'spec_helper'

describe "java" do
  let(:facts) { default_test_facts }
  let(:params) {
    {
      :update_version => '92',
      :minor_version => 'b14',
    }
  }

  it do
    should contain_class('boxen::config')
    should contain_class('wget')

    should contain_file('/test/boxen/bin/java').with({
      :source  => 'puppet:///modules/java/java.sh',
      :mode    => '0755'
    })

    should contain_exec("download jdk-8u#{params[:update_version]}-macosx-x64.dmg").with({
      :command => "wget --quiet --no-check-certificate --no-cookies --header \'Cookie: oraclelicense=accept-securebackup-cookie\' http://download.oracle.com/otn-pub/java/jdk/8u#{params[:update_version]}-#{params[:minor_version]}/jdk-8u#{params[:update_version]}-macosx-x64.dmg -P /Library/Java/JavaVirtualMachines",
      :user    => 'root',
      :creates => "/Library/Java/JavaVirtualMachines/jdk-8u#{params[:update_version]}-macosx-x64.dmg",
      :require => 'Package[wget]',
    })

    should contain_package("jdk-8u#{params[:update_version]}-macosx-x64.dmg").with({
      :provider => 'appdmg_eula',
      :source   => "/Library/Java/JavaVirtualMachines/jdk-8u#{params[:update_version]}-macosx-x64.dmg",
    })
  end
end
