class java($version='7u17') {

  $jre_url = "https://dl.dropbox.com/u/205010/puppet-java/${version}/jre-${version}-macosx-x64.dmg"
  $jdk_url = "https://dl.dropbox.com/u/205010/puppet-java/${version}/jdk-${version}-macosx-x64.dmg"
  $wrapper = "${boxen::config::bindir}/java"

  package {
    'jre-${version}.dmg':
      ensure   => present,
      alias    => 'java-jre',
      provider => pkgdmg,
      source   => $jre_url ;
    'jdk-${version}.dmg':
      ensure   => present,
      alias    => 'java',
      provider => pkgdmg,
      source   => $jdk_url ;
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => 0755,
    require => Package['java']
  }
}