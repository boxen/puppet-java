class java {
  $jre_url = 'https://s3.amazonaws.com/boxen-downloads/java/jre-7u13.dmg'
  $jdk_url = 'https://s3.amazonaws.com/boxen-downloads/java/jdk-7u13.dmg'
  $wrapper = "${boxen::config::bindir}/java"

  package {
    'jre-7u13.dmg':
      ensure   => present,
      alias    => 'java-jre',
      provider => pkgdmg,
      source   => $jre_url ;
    'jdk-7u13.dmg':
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
