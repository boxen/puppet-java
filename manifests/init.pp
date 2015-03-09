# Public: installs java jre-7u51 and JCE unlimited key size policy files
#
# Examples
#
#    include java
class java (
  $java_major_version = '7',
  $update_version = '71',
  $base_download_url = 'https://s3.amazonaws.com/boxen-downloads/java'
) {
  include boxen::config

  $new_java_version = "1.${java_major_version}-${update_version}"
  $jre_url = "${base_download_url}/jre-${java_major_version}-macosx-x64.dmg"
  $jdk_url = "${base_download_url}/jdk-${java_major_version}-macosx-x64.dmg"
  $wrapper = "${boxen::config::bindir}/java"
  $jdk_dir = "/Library/Java/JavaVirtualMachines/jdk1.${java_major_version}.0.jdk"
  $sec_dir = "${jdk_dir}/Contents/Home/jre/lib/security"

  if ((versioncmp($::macosx_productversion_major, '10.10') >= 0) and
    (versioncmp($update_version, '71') < 0) and $java_major_version == '7')
  {
    fail('Yosemite Requires Java 7 with a patch level >= 71 (Bug JDK-8027686)')
  }

  if ((versioncmp($::macosx_productversion_major, '10.10') >= 0) and
    (versioncmp($update_version, '20') < 0) and $java_major_version == '8')
  {
    fail('Yosemite Requires Java 8 with a patch level >= 20 (Bug JDK-8027686)')
  }

  if (versioncmp($::java_version, $new_java_version) < 0) {
    package {
      "jre-${java_major_version}u${update_version}.dmg":
        ensure   => present,
        alias    => 'java-jre',
        provider => pkgdmg,
        source   => $jre_url ;
      "jdk-${java_major_version}u${update_version}.dmg":
        ensure   => present,
        alias    => 'java',
        provider => pkgdmg,
        source   => $jdk_url ;
    }
  }
  else {
    notify { "You requested ${new_java_version} be installed, but you already have ${::java_version} which is more recent!": }
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => '0755'
  }

  # Allow 'large' keys locally.
  # http://www.ngs.ac.uk/tools/jcepolicyfiles
  file { $sec_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0775',
    require => Package['java']
  }

  file { "${sec_dir}/local_policy.jar":
    source  => 'puppet:///modules/java/local_policy.jar',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0664',
    require => File[$sec_dir]
  }

  file { "${sec_dir}/US_export_policy.jar":
    source  => 'puppet:///modules/java/US_export_policy.jar',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0664',
    require => File[$sec_dir]
  }
}