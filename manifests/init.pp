# Public: installs java jdk and JCE unlimited key size policy files
#
# Examples
#
#    include java

class java (
  $major_version = '14.0.1',
  $minor_version = '7',
  $hash_version  = '664493ef4a6946b186ff29eb326336a2'
) {
  include boxen::config

  $wrapper = "${boxen::config::bindir}/java"
  $jdk_download_url = "https://download.oracle.com/otn-pub/java/jdk/${major_version}+${minor_version}/${hash_version}"
  $jdk_package = "jdk-${major_version}_osx-x64_bin.dmg"
  $jdk_dir = '/Library/Java/JavaVirtualMachines'

  file { $wrapper:
    source => 'puppet:///modules/java/java.sh',
    mode   => '0755',
  }

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
