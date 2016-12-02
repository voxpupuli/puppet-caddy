# Class caddy::params
# ===========================
#
# Default values for caddy module
#
class caddy::params {

  case $facts['os']['family'] {
    'RedHat':  {
      $install_path   = '/usr/bin'
      $caddy_user     = 'www-data'
      $caddy_log_dir  = '/var/log/caddy'
    }

    default:  {
      fail("${facts['os']['family']} is not supported.")
    }
  }
}
