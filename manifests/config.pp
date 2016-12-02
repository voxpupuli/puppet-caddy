# Class caddy::config
# ===========================
#
# Caddy server setup

class caddy::config (

  $install_path  = $caddy::install_path,
  $caddy_user    = $caddy::caddy_user,
  $caddy_log_dir = $caddy::caddy_log_dir,

  ){

  group {$caddy_user:
    system => true,
  }

  user {$caddy_user:
    ensure => present,
    shell  => '/sbin/nologin',
    system => true,
    home   => 'etc/ssl/caddy',
  }

  file {$caddy_log_dir:
    ensure  => directory,
    owner   => $caddy_user,
    group   => $caddy_user,
    mode    => '0755',
    require => User[$caddy_user],
  }

  file {'/etc/caddy':
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file {'/etc/caddy/Caddyfile':
    ensure  => file,
    mode    => '0444',
    owner   => $caddy_user,
    group   => $caddy_user,
    content => template('caddy/etc/caddy/Caddyfile.erb'),
    require => File['/etc/caddy'],
  }

  file {'/etc/caddy/config':
    ensure  => directory,
    purge   => true,
    recurse => true,
    mode    => '0755',
    owner   => $caddy_user,
    group   => $caddy_user,
    require => User[$caddy_user],
  }

  file {'/etc/ssl/caddy':
    ensure  => directory,
    owner   => $caddy_user,
    group   => $caddy_user,
    mode    => '0755',
    require => User[$caddy_user],
  }

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
}
