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

  # Dell DRAC and Java 7 Certificate Fix
  # http://people.binf.ku.dk/~hanne/b2evolution/blogs/index.php/2012/08/09/dell-idrac-7-will-not
  file { [
    "/Users/${::boxen_user}/.java",
    "/Users/${::boxen_user}/.java/deployment",
    "/Users/${::boxen_user}/.java/deployment/security"
  ]:
      ensure => directory,
      mode   => '0750';
    "/Users/${::boxen_user}/.java/deployment/security/trusted.certs":
      ensure => file,
      mode   => '0640',
      source => 'puppet:///modules/java/trusted.certs';
    "/Users/${::boxen_user}/.java/deployment/security/trusted.jssecerts":
      ensure => file,
      mode   => '0640',
      source => 'puppet:///modules/java/trusted.jssecerts';
  }
}
