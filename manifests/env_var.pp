#
# Set system environment variables
#
define system_proxy::env_var(
  $var    = $name,
  $value  = undef,
  $ensure = 'present',
) {
  ini_setting { "env-${$name}":
    ensure            => $ensure,
    path              => '/etc/environment',
    section           => '',
    setting           => $var,
    value             => $value,
    key_val_separator => '=',
  }
}
