require 'spec_helper'

describe "java" do
  let(:facts) { default_test_facts }
  let(:params) {
    {
      :major_version => '14.0.1',
      :minor_version => '7',
      :hash_version  => '664493ef4a6946b186ff29eb326336a2'
    }
  }

  it do
    should contain_class('boxen::config')

    should contain_file('/test/boxen/bin/java').with({
      :source => 'puppet:///modules/java/java.sh',
      :mode   => '0755'
    })

    should contain_exec("download jdk-#{params[:major_version]}_osx-x64_bin.dmg").with({
      :command => "wget --quiet --no-check-certificate --no-cookies --header \'Cookie: oraclelicense=accept-securebackup-cookie\' https://download.oracle.com/otn-pub/java/jdk/#{params[:major_version]}+#{params[:minor_version]}/#{params[:hash_version]}/jdk-#{params[:major_version]}_osx-x64_bin.dmg -P /Library/Java/JavaVirtualMachines",
      :user    => 'root',
      :creates => "/Library/Java/JavaVirtualMachines/jdk-#{params[:major_version]}_osx-x64_bin.dmg",
      :require => 'Package[wget]',
    })

    should contain_package("jdk-#{params[:major_version]}_osx-x64_bin.dmg").with({
      :provider => 'pkgdmg',
      :source   => "/Library/Java/JavaVirtualMachines/jdk-#{params[:major_version]}_osx-x64_bin.dmg",
      :require  => "Exec[download jdk-#{params[:major_version]}_osx-x64_bin.dmg]",
    })
  end
end
