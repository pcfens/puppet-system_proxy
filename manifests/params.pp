# class params
#
class system_proxy::params {
  $proxy_type         = 'http'
  $unless_network     = []
  $unless_ip_in_range = []

  $environment_vars   = [ 'PIP_PROXY',
                          'https_proxy',
                          'HTTPS_PROXY',
                        ]
}
