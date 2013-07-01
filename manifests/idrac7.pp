class java::idrac7 {
  include java

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
