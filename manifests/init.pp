class java {
  $url = 'http://s3.amazonaws.com/github-setup/java-201206.dmg'

  package { 'java-201206':
    ensure   => present,
    provider => pkgdmg,
    source   => $url
  }
}
