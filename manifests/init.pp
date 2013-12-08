# Public: installs java jre-7u21 and JCE unlimited key size policy files
#
# Examples
#
#    include java
class java {
  include boxen::config

  $jre_url = 'https://s3.amazonaws.com/boxen-downloads/java/jre-7u21-macosx-x64.dmg'
  $jdk_url = 'https://s3.amazonaws.com/boxen-downloads/java/jdk-7u21-macosx-x64.dmg'
  $wrapper = "${boxen::config::bindir}/java"
  $sec_dir = '/Library/Java/JavaVirtualMachines/jdk1.7.0_21.jdk/Contents/Home/jre/lib/security'

  package {
    'jre-7u21.dmg':
      ensure   => present,
      alias    => 'java-jre',
      provider => pkgdmg,
      source   => $jre_url ;
    'jdk-7u21.dmg':
      ensure   => present,
      alias    => 'java',
      provider => pkgdmg,
      source   => $jdk_url ;
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => '0755',
    require => Package['java']
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
