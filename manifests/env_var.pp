#
# Set system environment variables
#
define system_proxy::env_var(
  $var   = $name,
  $value = undef,
) {
  ini_setting { "env-${$name}":
    ensure            => present,
    path              => '/etc/environment',
    section           => '',
    setting           => $var,
    value             => $value,
    key_val_separator => '=',
  }
}
