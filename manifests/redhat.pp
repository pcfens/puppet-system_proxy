#
# Private class system_proxy::redhat
#
class system_proxy::redhat (
  $username  = undef,
  $password  = undef,
  $proxy_uri = undef,
) {

  if $::operatingsystem != 'RedHat'{
    fail('The ::system_proxy::redhat class should only be applied to RHEL
    systems')
  }

  ini_setting { 'proxy_enable':
    ensure            => present,
    path              => '/etc/sysconfig/rhn/up2date',
    section           => '',
    setting           => 'enableProxy',
    value             => 1,
    key_val_separator => '=',
  }

  ini_setting { 'proxy_uri':
    ensure            => present,
    path              => '/etc/sysconfig/rhn/up2date',
    section           => '',
    setting           => 'httpProxy',
    value             => $proxy_uri,
    key_val_separator => '=',
  }

  if $username and $password {
    ini_setting { 'proxy_auth_enable':
      ensure            => present,
      path              => '/etc/sysconfig/rhn/up2date',
      section           => '',
      setting           => 'enableProxyAuth',
      value             => 1,
      key_val_separator => '=',
    }

    ini_setting { 'proxy_user':
      ensure            => present,
      path              => '/etc/sysconfig/rhn/up2date',
      section           => '',
      setting           => 'proxyUser',
      value             => $username,
      key_val_separator => '=',
    }

    ini_setting { 'proxy_password':
      ensure            => present,
      path              => '/etc/sysconfig/rhn/up2date',
      section           => '',
      setting           => 'proxyPassword',
      value             => $password,
      key_val_separator => '=',
    }
  } else {
    ini_setting { 'proxy_auth_enable':
      ensure            => present,
      path              => '/etc/sysconfig/rhn/up2date',
      section           => '',
      setting           => 'enableProxyAuth',
      value             => 0,
      key_val_separator => '=',
    }
  }

}
