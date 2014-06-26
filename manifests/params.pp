# class params
#
class system_proxy::params {
  $proxy_type       = 'http'
  $unless_network   = []

  $environment_vars = [ 'PIP_PROXY',
                      ]
}
