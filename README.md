puppet-system_proxy
===================

[![Build Status](https://travis-ci.org/pcfens/puppet-system_proxy.png?branch=master)](https://travis-ci.org/pcfens/puppet-system_proxy)

Overview
--------

Automate the configuration of a system wide proxy to access the internet, when
needed. If a network specified in the `unless_network` parameter exists on the
system, then nothing is configured, and a notice is written to the log.

Usage
-----

The most basic usage (to configure an unauthenticated http proxy) looks like
```puppet
class { 'system_proxy':
  proxy_host => 'http://example.proxy.com'
}
```

With every parameter set, usage looks like
```puppet
class { 'system_proxy':
  proxy_host         => 'http://proxy.example.com',
  proxy_port         => 80,
  proxy_type         => 'http',
  username           => 'ImAUser',
  password           => 'ASuperSecretPassword',
  unless_network     => ['10.0.1.0'],
  unless_ip_in_range => ['192.168.0.1/24'],
  environment_vars   => ['PIP_PROXY', 'HTTPS_PROXY', 'https_proxy'],
}
```

Supported Platforms
-------------------

This module has been tested on Ubuntu 12.04 and Ubuntu 14.04.

It should work on RHEL/CentOS, and includes configuration for up2date/yum on
RHEL.
