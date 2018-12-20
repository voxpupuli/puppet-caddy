# Class caddy::params
# ===========================
#
# Default values for caddy module
#
class caddy::params {

  case $::architecture {
    'x86_64': { $arch = 'amd64'}
    'x86'   : { $arch = '386' }
    default:  {
      fail("${::architecture} is not supported.")
    }
  }

  case $::osfamily {
    'RedHat':  {
      $install_path          = '/usr/local/bin'
      $caddy_home            = '/etc/ssl/caddy'
      $caddy_user            = 'caddy'
      $caddy_group           = 'caddy'
      $caddy_license         = 'personal'
      $caddy_account_id      = undef
      $caddy_api_key         = undef
      $caddy_telemetry       = 'off'
      $caddy_features        = 'http.filter,http.git,http.ipfilter'
      $caddy_log_dir         = '/var/log/caddy'
      $caddy_tmp_dir         = '/tmp'
      $caddy_ssl_dir         = "${caddy_home}/.caddy"
      $caddy_http_port       = 80
      $caddy_https_port      = 443
      $caddy_private_devices = true
      $caddy_limit_processes = 64
    }

    default:  {
      fail("${::osfamily} is not supported.")
    }
  }
}
