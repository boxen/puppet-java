require 'spec_helper'

describe "java::idrac7" do
  let(:facts) { default_test_facts }

  it do
    should contain_class('java')

    ['.java', '.java/deployment', '.java/deployment/security'].each do |dir|
      should contain_file("/Users/testuser/#{dir}").with({
        :ensure => 'directory',
        :mode   => '0750'
      })
    end

    should contain_file("/Users/testuser/.java/deployment/security/trusted.certs").with({
      :ensure => 'file',
      :mode   => '0640',
      :source => 'puppet:///modules/java/trusted.certs'
    })

    should contain_file("/Users/testuser/.java/deployment/security/trusted.jssecerts").with({
      :ensure => 'file',
      :mode   => '0640',
      :source => 'puppet:///modules/java/trusted.jssecerts'
    })
  end
end
