# Class caddy::service
# ===========================
#
# Manage caddy service
#
class caddy::service inherits caddy {

  case $facts['os']['release']['major'] {
    '7': {
      file {'/etc/systemd/system/caddy.service':
        ensure  => file,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        content => template('caddy/etc/systemd/system/caddy.service.erb'),
        notify  => Exec['systemctl-daemon-reload'],
        require => Class['caddy::package'],
      }

      exec {'systemctl-daemon-reload':
        refreshonly => true,
        path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
        command     => 'systemctl daemon-reload',
      }
    }
    '6': {
      file {'/etc/init.d/caddy':
        ensure  => file,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        content => template('caddy/etc/init.d/caddy.erb'),
        require => Class['caddy::package'],
      }
    }
    default:  {
      fail("${facts['os']['family']} is not supported.")
    }
  }

  service{'caddy':
    ensure => running,
    enable => true,
  }
}
