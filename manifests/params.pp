# Class caddy::params
# ===========================
#
# Default values for caddy module
#
class caddy::params {

  $install_method                = 'official' # Allowed values: github, official, (source, not implemented yet)
  $version                       = '1.0.0'
  $install_path                  = '/usr/local/bin'
  $caddy_license                 = 'personal'
  $caddy_account_id              = undef
  $caddy_api_key                 = undef
  $caddy_telemetry               = 'off'
  $caddy_features                = 'http.filter,http.git,http.ipfilter'
  $caddy_log_dir                 = '/var/log/caddy'
  $caddy_tmp_dir                 = '/tmp'
  $caddy_http_port               = 80
  $caddy_https_port              = 443
  $caddy_private_devices         = true
  $caddy_limit_processes         = 64
  # Ubuntu 18.04 ships with systemd v234, > v229
  $systemd_capabilityboundingset = undef
  $systemd_ambientcapabilities   = undef
  $systemd_nonewprivileges       = undef

  case $facts['os']['architecture'] {
    'x86_64', 'amd64': { $arch = 'amd64'}
    'x86'            : { $arch = '386' }
    default:  {
      fail("${facts['os']['architecture']} is not supported.")
    }
  }

  case $facts['os']['family'] {
    'RedHat':  {
      $caddy_home            = '/etc/ssl/caddy'
      $caddy_user            = 'caddy'
      $caddy_group           = 'caddy'
      $caddy_ssl_dir         = "${caddy_home}/.caddy"
    }
    'Debian':  {
      $caddy_home            = '/opt/caddy'
      $caddy_user            = 'www-data'
      $caddy_group           = 'www-data'
      $caddy_ssl_dir         = "${caddy_home}/.caddy"
    }
    default:  {
      fail("${facts['os']['family']} is not supported.")
    }
  }
}
