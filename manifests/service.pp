# Class caddy::service
# ===========================
#
# Manage caddy service
#
class caddy::service (
  $install_path          = $caddy::install_path,
  $caddy_user            = $caddy::caddy_user,
  $caddy_group           = $caddy::caddy_group,
  $caddy_log_dir         = $caddy::caddy_log_dir,
  $caddy_tmp_dir         = $caddy::caddy_tmp_dir,
  $caddy_ssl_dir         = $caddy::caddy_ssl_dir,
  $caddy_home            = $caddy::caddy_home,
  $caddy_http_port       = $caddy::caddy_http_port,
  $caddy_https_port      = $caddy::caddy_https_port,
  $caddy_private_devices = $caddy::caddy_private_devices,
  $caddy_limit_processes = $caddy::caddy_limit_processes,
) {

  assert_private()

  case $facts['service_provider'] {
    'systemd': {
      systemd::unit_file { 'caddy.service':
        content => template('caddy/etc/systemd/system/caddy.service.erb'),
        require => Class['caddy::package'],
      }
    }
    'redhat': { # we could probably add 'debian' for older debian releases but not sure
      file {'/etc/init.d/caddy':
        ensure  => file,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        content => template('caddy/etc/init.d/caddy.erb'),
      }
    }
    default:  {
      fail("service provider ${$facts['service_provider']} is not supported.")
    }
  }

<<<<<<< HEAD
  service{ 'caddy':
=======
  -> service{'caddy':
>>>>>>> 654e1ce... Added default parameter values to module manifest for puppet-strings support.
    ensure => running,
    enable => true,
  }
}
