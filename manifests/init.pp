class java {
  $url     = 'http://s3.amazonaws.com/github-setup/java-201206.dmg'
  $wrapper = "${boxen::config::bindir}/java"

  package { 'java-201206':
    ensure   => present,
    provider => pkgdmg,
    source   => $url
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => 0755,
    require => Package['java-201206']
  }
}
