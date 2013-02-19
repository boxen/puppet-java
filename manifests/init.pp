class java {
  $version = '7u15'
  $jre_url = 'https://edelivery.oracle.com/otn-pub/java/jdk/7u15-b03/jre-7u15-macosx-x64.dmg'
  $jdk_url = 'https://edelivery.oracle.com/otn-pub/java/jdk/7u15-b03/jdk-7u15-macosx-x64.dmg'
  $jdk_cookie = 'gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk7-downloads-1880260.html'
  $jre_cookie = 'gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjre7-downloads-1880261.html'
  $wrapper = "${boxen::config::bindir}/java"

  exec {
    'get-jdk':
      command => "curl -L --cookie $jdk_cookie -o /tmp/jdk-7u15.dmg $jdk_url",
      creates => "/tmp/jdk-7u15.dmg",
  }
  exec {
    'get-jre':
      command => "curl -L --cookie $jre_cookie -o /tmp/jre-7u15.dmg $jre_url",
      creates => "/tmp/jre-7u15.dmg",
  }
  package {
    'jre-7u13.dmg':
      ensure   => present,
      alias    => 'java-jre',
      provider => pkgdmg,
      source   => '/tmp/jre-7u15.dmg' ;
    'jdk-7u13.dmg':
      ensure   => present,
      alias    => 'java',
      provider => pkgdmg,
      source   => '/tmp/jdk-7u15.dmg' ;
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => 0755,
    require => Package['java']
  }
}
