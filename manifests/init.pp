# Public: installs java jre-7u51 and JCE unlimited key size policy files
#
# Examples
#
#    include java
class java (
  $update_version = '71',
  $base_download_url = 'https://s3.amazonaws.com/boxen-downloads/java'
) {
  include boxen::config

  $jre_url = "${base_download_url}/jre-7u${update_version}-macosx-x64.dmg"
  $jdk_url = "${base_download_url}/jdk-7u${update_version}-macosx-x64.dmg"
  $wrapper = "${boxen::config::bindir}/java"
  $jdk_dir = "/Library/Java/JavaVirtualMachines/jdk1.7.0_${update_version}.jdk"
  $sec_dir = "${jdk_dir}/Contents/Home/jre/lib/security"

  if ((versioncmp($::macosx_productversion_major, '10.10') >= 0) and
    versioncmp($update_version, '71') < 0)
  {
    fail('Yosemite Requires Java 7 with a patch level >= 71 (Bug JDK-8027686)')
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => '0755'
  }

  if (versioncmp($::java_jre_version, '1.8.0') < 0) {
    package {
      "jre-7u${update_version}.dmg":
        ensure   => present,
        alias    => 'java-jre',
        provider => pkgdmg,
        source   => $jre_url ;
    }
  }

  if (versioncmp($::java_version, '1.8.0') < 0) {
    package {
      "jdk-7u${update_version}.dmg":
        ensure   => present,
        alias    => 'java',
        provider => pkgdmg,
        source   => $jdk_url ;
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
}
