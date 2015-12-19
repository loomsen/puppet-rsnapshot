# rsnapshot

[![Build Status](https://travis-ci.org/OpenConceptConsulting/puppet-rsnapshot.svg?branch=master)](https://travis-ci.org/OpenConceptConsulting/puppet-rsnapshot)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with rsnapshot](#setup)
    * [What rsnapshot affects](#what-rsnapshot-affects)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This puppet module manages rsnapshot configuration. It's a barebones module, as it doesn't deal with managing ssh keys or cron rules to trigger rsnapshot.

At the moment, this module has been tested with Puppet 3.x and Ubuntu 12.04, 14.04 and Debian 6. If you have another OS/Puppet version you want to include, please submit a pull request!

## Module Description

This module is a barebones rsnapshot installation and configuration system. It came into existing because we needed an rsnapshot module but didn't want to have it generate cron rules or setup ssh keys (rsnapshot only needs to generate local backups for us).

It is relatively trivial to then add a `cron` rule to trigger rsnapshot, and managing ssh keys can be done through `ssh_authorized_key`.

## Setup

### What rsnapshot affects

* `rsnapshot` package and its dependencies
* `/etc/rsnapshot.conf` (by default)

## Usage

You only need to declare the rsnapshot class, and configure the parameters you need.
The class will default to sane values for your OS if you don't override some parameters.

While you can include the class as is, it wont be useful unless you specify `backups` or `backup_scripts`.

## Reference

### backups
A hash backup locations. The key is the source, the value is the destination.

```
class { 'rsnapshot':
  backups => {
    '/home/' => 'localhost/',
  }
}
```

If you want the backup stanza to have overriden configuration options, add them to the destination, separated by a tab character:

```
class { 'rsnapshot':
  backups => {
    '/home/' => 'localhost/	one_fs=1',
  }
}
```

### backup_scripts
Exactly like [backups](#backups), except that they generate `backup_script` stanzas.

## Limitations

The module has been tested/used in production with Puppet 3.x.

On the OS side, the module currently only works on Debian-family OSes, but we'd love to get a patch to add support for more families/operating systems.

## Development

Development is happening on [github](https://github.com/OpenConceptConsulting/puppet-rsnapshot), and we welcome pull requests!
