class java {
  $url     = 'http://javadl.sun.com/webapps/download/AutoDL?BundleId=73851'
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
