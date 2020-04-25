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

  case $facts['os']['release']['major'] {
    '7': {
      file { '/etc/systemd/system/caddy.service':
        ensure  => file,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        content => template('caddy/etc/systemd/system/caddy.service.erb'),
        notify  => Exec['systemctl-daemon-reload'],
      }

      exec {'systemctl-daemon-reload':
        refreshonly => true,
        path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
        command     => 'systemctl daemon-reload',
      }
    }
    '6': {
      file { '/etc/init.d/caddy':
        ensure  => file,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        content => template('caddy/etc/init.d/caddy.erb'),
      }
    }
    default:  {
      fail("${facts['os']['family']} is not supported.")
    }
  }

  service{ 'caddy':
    ensure => running,
    enable => true,
  }
}
