# Java Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-java.png?branch=master)](https://travis-ci.org/boxen/puppet-java)

Installs Java 8.


## Usage

```puppet
# Install the default version of both the JDK and JRE
include java
```

## Parameters

You can customise this module by configuring some optional class parameters. Usually you'd do this via Hiera, but you could also explicitly pass those parameters in puppet code like `class { 'java': update_version => '42', }`.

* `update_version`: The 'update' part of the JDK version to install. For example, if you specify `65`, the module would install java 8u65
* `minor_version`: The 'minor' part of the JDK download URL. For example download URL is http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-macosx-x64.dmg, minor verson is 'b17'.

All of these parameters have sensible defaults, and are provided if you need more control.

Example hiera data in YAML:

```yaml
java::update_version: '65'
java::minor_version: 'b17'
```

## Required Puppet Modules

* `boxen`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
