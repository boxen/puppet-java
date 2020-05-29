# Java Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-java.png?branch=master)](https://travis-ci.org/boxen/puppet-java)

Installs Oracle Java 8.


## Usage

```puppet
# Install the default version of both the JDK and JRE
include java
```

## Parameters

You can customise this module by configuring some optional class parameters. Usually you'd do this via Hiera, but you could also explicitly pass those parameters in puppet code like `class { 'java': update_version => '152', minor_Version => 'b16', hash_versoin => 'aa0333dd3019491ca4f6ddbe78cdb6d0' }`.

* `update_version`: The 'update' part of the JDK version to install. For example, if you specify `152`, the module would install java 8u152
* `minor_version`, `hash_version`: The 'minor' part of the JDK download URL. For example download URL is http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jdk-8u152-macosx-x64.dmg, minor verson is 'b16'.

All of these parameters have sensible defaults, and are provided if you need more control.

Example hiera data in YAML:

```yaml
java::update_version: '152'
java::minor_version: 'b16'
java::hash_version: 'aa0333dd3019491ca4f6ddbe78cdb6d0'
```

## Required Puppet Modules

* `boxen`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
