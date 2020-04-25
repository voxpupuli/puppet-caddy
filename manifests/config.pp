# Class caddy::config
# ===========================
#
# Caddy server setup

class caddy::config inherits caddy {

  group {$caddy::caddy_group:
    ensure => present,
    system => true,
  }

  user {$caddy::caddy_user:
    ensure     => present,
    shell      => '/sbin/nologin',
    gid        => $caddy::caddy_group,
    system     => true,
    home       => $caddy::caddy_home,
    managehome => true,
  }

  file {
    default:
      ensure => directory,
      owner  => $caddy::caddy_user,
      group  => $caddy::caddy_group,
      mode   => '0755',
    ;
    [ $caddy::caddy_ssl_dir,
      $caddy::caddy_log_dir,
    ]:
      require => User[$caddy::caddy_user],
    ;
    [ '/etc/caddy' ]:
      owner => 'root',
      group => 'root',
    ;

    [ '/etc/caddy/Caddyfile' ]:
      ensure  => file,
      mode    => '0444',
      source  => 'puppet:///modules/caddy/etc/caddy/Caddyfile',
      require => File['/etc/caddy'],
    ;

    [ '/etc/caddy/config' ]:
      purge   => true,
      recurse => true,
      require => User[$caddy::caddy_user],
    ;
  }

  case $facts['os']['release']['major'] {
    '7': {
      file {'/etc/systemd/system/caddy.service':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0744',
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
        owner   => 'root',
        group   => 'root',
        mode    => '0744',
        content => template('caddy/etc/init.d/caddy.erb'),
        require => Class['caddy::package'],
      }
    }
    default:  {
      fail("${facts['os']['family']} is not supported.")
    }
  }
}
