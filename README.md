# Java Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-java.png?branch=master)](https://travis-ci.org/boxen/puppet-java)

Installs Java 8 and unlimited key length security policy files..


## Usage

```puppet
# Install the default version of both the JDK and JRE
include java
```

## Parameters

You can customise this module by configuring some optional class parameters. Usually you'd do this via Hiera, but you could also explicitly pass those parameters in puppet code like `class { 'java': update_version => '25', }`.

* `base_download_url`: A base path from which the JRE and JDK packages should be downloaded. For example, if you specify `https://myorg.example/dist/java`, this module would download the jre from `https://myorg.example/dist/java/jre-8u25-macosx-x64.dmg`.

All of these parameters have sensible defaults, and are provided if you need more control.

Example hiera data in YAML:

```yaml
java::base_download_url: 'https://myorg.example/dist/java'
```

## Required Puppet Modules

* `boxen`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
