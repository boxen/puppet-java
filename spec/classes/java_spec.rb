require 'spec_helper'

describe "java" do
  context "default parameters"
  let(:facts) {
    default_test_facts.merge({ :macosx_productversion_major => '10.10' })
  }

  it do
    should contain_class('boxen::config')

    should contain_package('jre-7u71.dmg').with({
      :ensure   => 'present',
      :alias    => 'java-jre',
      :provider => 'pkgdmg',
      :source   => 'https://s3.amazonaws.com/boxen-downloads/java/jre-7u71-macosx-x64.dmg'
    })

    should contain_package('jdk-7u71.dmg').with({
      :ensure   => 'present',
      :alias    => 'java',
      :provider => 'pkgdmg',
      :source   => 'https://s3.amazonaws.com/boxen-downloads/java/jdk-7u71-macosx-x64.dmg'
    })

    should contain_file('/test/boxen/bin/java').with({
      :source  => 'puppet:///modules/java/java.sh',
      :mode    => '0755'
    })
  end

  context 'fails when java version has Yosemite relevant bug' do
    context "java 7" do
      let(:facts) { default_test_facts.merge({ :macosx_productversion_major => '10.10' }) }
      let(:params) {
        {
          :update_major_version => '7',
          :update_version     => '51',
        }
      }
      it do
        expect {
          should contain_class('java')
        }.to raise_error(/Yosemite Requires Java 7 with a patch level >= 71 \(Bug JDK\-8027686\)/)
      end
    end
    context "java 8" do
      let(:facts) { default_test_facts.merge({ :macosx_productversion_major => '10.10' }) }
      let(:params) {
        {
          :update_major_version => '8',
          :update_version     => '11',
        }
      }
      it do
        expect {
          should contain_class('java')
        }.to raise_error(/Yosemite Requires Java 8 with a patch level >= 20 \(Bug JDK\-8027686\)/)
      end
    end
  end

  context 'doesnt install java if newer version already present' do
    context "trying to install Java 7 when Java 8 already installed" do
      let(:facts) { default_test_facts.merge({
        :java_version => '1.8.0_21',
      })
      }
      let(:params) {
        {
          :update_major_version => '7',
          :update_version     => '71',
        }
      }
      it do
        should contain_class('boxen::config')
        should_not contain_package('jre-7u71.dmg')
      end
    end
    context "trying to install Java 7 when a higher patch version already installed" do
      let(:facts) { default_test_facts.merge({
        :java_version => '1.7.0_71',
      })
      }
      let(:params) {
        {
          :update_major_version => '7',
          :update_version     => '20',
        }
      }
      it do
        should contain_class('boxen::config')
        should_not contain_package('jre-7u20.dmg')
      end
    end
  end

end
