class java {
  $url     = 'https://s3.amazonaws.com/boxen-downloads/java/jre-7u13-macosx-x64.dmg'
  $wrapper = "${boxen::config::bindir}/java"

  package { 'jre-7u13-macosx-x64.dmg':
    ensure   => present,
    alias    => 'java',
    provider => pkgdmg,
    source   => $url
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => 0755,
    require => Package['java']
  }
}
