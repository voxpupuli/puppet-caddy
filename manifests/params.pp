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
      $install_path  = '/usr/local/bin'
      $caddy_user    = 'caddy'
      $caddy_home    = '/etc/ssl/caddy'
      $caddy_group   = 'caddy'
      $caddy_log_dir = '/var/log/caddy'
      $caddy_tmp_dir = '/tmp'
    }

    default:  {
      fail("${::osfamily} is not supported.")
    }
  }
}
