# == Class: system_proxy
#
# Manage the proxy settings on a Linux system, if needed.
#
# This module has been tested primarily on Ubuntu/Debian systems,
# but is designed to work on RH (and variants) as well.
#
# === Parameters
#
# [*proxy_host*]
#   The hostname of the proxy server (e.g. proxy.example.com)
# [*proxy_port*]
#   The port number the client should use to connect to the proxy server.
#   The default value is based on the proxy_type.
# [*proxy_type*]
#   The proxy type (http, https, etc.). Defaults to http.
# [*username*]
#   If needed, the username to connect to the proxy server
# [*password*]
#   If needed, the password to connect to the proxy server
# [*unless_network*]
#   If one of the networks listed in the array is present on the system, then
#   all proxy setup will be skipped. Useful when you apply this module to
#   everything in your infrastructure, but want to skip on machines that don't
#   or shouldn't be talking to the proxy server.
# [*environment_vars*]
#   An array of additional environment variables that should contain the proxy
#   connection information. Defaults to ['PIP_PROXY'].
#
# === Examples
#
#  class { 'system_proxy':
#    'proxy_host'       => 'proxy.example.com',
#    'proxy_port'       => 80,
#    'unless_network'   => ['10.0.10.0'],
#  }
#
# === Authors
#
# Phil Fenstermacher <phillip.fenstermacher@gmail.com>
#
class system_proxy (
  $proxy_host       = undef,
  $proxy_port       = undef,
  $username         = undef,
  $password         = undef,
  $proxy_type       = $system_proxy::params::proxy_type,
  $unless_network   = $system_proxy::params::unless_network,
  $environment_vars = $system_proxy::params::environment_vars,
) inherits ::system_proxy::params {
  if $proxy_port == undef {
    $proxy_port_real = $proxy_type ? {
      'http'  => 80 ,
      'https' => 443,
      default => undef,
    }
  } else {
    $proxy_port_real = $proxy_port
  }

  if $proxy_port_real == undef {
    fail("There is no default proxy port for a ${proxy_type} proxy")
  }

  if $username and $password {
    $user_pass = "${username}:${password}@"
  }

  $proxy_uri = "${proxy_type}://${user_pass}${proxy_host}:${proxy_port_real}"

  # We can skip the custom function when the future parser is
  # standard.
  if !has_ip_network_list($unless_network) {

    $environment_vars_real = union( [
                                      downcase("${proxy_type}_proxy"),
                                      upcase("${proxy_type}_proxy") ],
                                      $environment_vars
                                    )
    ::system_proxy::env_var { $environment_vars_real:
      value => "${proxy_type}://${proxy_host}:${proxy_port_real}",
    }

    if $::operatingsystem == 'RedHat' {
      class { 'system_proxy::redhat':
        username  => $username,
        password  => $password,
        proxy_uri => "${proxy_type}://${proxy_host}:${proxy_port_real}",
      }
    }

  } else {
    notice ( 'Skipping proxy setup - found a non-proxy network on the system' )
  }

}
