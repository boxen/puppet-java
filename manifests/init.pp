# Public: installs java jdk and JCE unlimited key size policy files
#
# Examples
#
#    include java
class java (
  $update_version = '65',
  $minor_version = 'b17'
) {
  include boxen::config
  include wget

  $wrapper = "${boxen::config::bindir}/java"
  $jdk_download_url = "http://download.oracle.com/otn-pub/java/jdk/8u${update_version}-${minor_version}"
  $jdk_package = "jdk-8u${update_version}-macosx-x64.dmg"
  $jdk_dir = '/Library/Java/JavaVirtualMachines'

  if ((versioncmp($::macosx_productversion_major, '10.10') >= 0) and
    versioncmp($update_version, '71') < 0)
  {
    fail('Yosemite Requires Java 7 with a patch level >= 71 (Bug JDK-8027686)')
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => '0755'
  }

  exec { "download jdk ${update_version}":
    command => "wget --quiet --no-check-certificate --no-cookies --header 'Cookie: oraclelicense=accept-securebackup-cookie' ${jdk_download_url}/${jdk_package} -P ${jdk_dir}",
    user => "root",
    creates => "${jdk_dir}/${jdk_package}",
    require => Package['wget'],
  }

  package { "jdk ${update_version}":
    provider => 'pkgdmg',
    source => "${jdk_dir}/${jdk_package}",
  }
}
