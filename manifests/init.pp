# Public: installs java jdk and JCE unlimited key size policy files
#
# Examples
#
#    include java

class java (
  $update_version = '161',
  $minor_version  = 'b12',
  $hash_version   = '2f38c3b165be4555a1fa6e98c45e0808'
) {
  include boxen::config

  $wrapper = "${boxen::config::bindir}/java"
  $jdk_download_url = "http://download.oracle.com/otn-pub/java/jdk/8u${update_version}-${minor_version}/${hash_version}"
  $jdk_package = "jdk-8u${update_version}-macosx-x64.dmg"
  $jdk_dir = '/Library/Java/JavaVirtualMachines'

  file { $wrapper:
    source => 'puppet:///modules/java/java.sh',
    mode   => '0755',
  }

  package { 'wget': }

  exec { "download ${jdk_package}":
    command => "wget --quiet --no-check-certificate --no-cookies --header 'Cookie: oraclelicense=accept-securebackup-cookie' ${jdk_download_url}/${jdk_package} -P ${jdk_dir}",
    user    => root,
    creates => "${jdk_dir}/${jdk_package}",
    require => Package['wget'],
  }

  package { $jdk_package:
    provider => pkgdmg,
    source   => "${jdk_dir}/${jdk_package}",
    require  => Exec["download ${jdk_package}"],
  }
}
