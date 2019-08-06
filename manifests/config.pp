# Class caddy::config
# ===========================
#
# Caddy server setup

class caddy::config inherits caddy {

  group {$caddy::caddy_group:
    ensure => present,
    system => true,
  }

  case $facts['os']['family'] {
    'RedHat':  {
      $nologin_shell = '/sbin/nologin'
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
        default: {
          fail("${facts['os']['name']} ${facts['os']['release']['major']} is not supported.")
        }
      }
    }
    'Debian':  {
      $nologin_shell = '/usr/sbin/nologin'
      case $facts['os']['release']['major'] {
        '18.04': {
          file {'/lib/systemd/system/caddy.service':
            ensure  => file,
            mode    => '0744',
            owner   => 'root',
            group   => 'root',
            content => template('caddy/lib/systemd/system/caddy.service.erb'),
            notify  => Exec['systemctl-daemon-reload'],
            require => Class['caddy::package'],
          }
          exec {'systemctl-daemon-reload':
            refreshonly => true,
            path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
            command     => 'systemctl daemon-reload',
          }
        }
        default: {
          fail("${facts['os']['family']} ${facts['os']['release']['major']} is not supported.")
        }
      }
    }
    default:  {
      fail("${facts['os']['family']} is not supported.")
    }
  }

  file { 'caddy home':
    ensure => directory,
    path   => $caddy::caddy_home,
    group  => $caddy::caddy_group,
  }

  user {$caddy::caddy_user:
    ensure  => present,
    shell   => $nologin_shell,
    gid     => $caddy::caddy_group,
    system  => true,
    home    => $caddy::caddy_home,
    require => [
      File['caddy home'],
      Group[$caddy::caddy_group],
    ],
  }

  file {$caddy::caddy_ssl_dir:
    ensure  => directory,
    owner   => $caddy::caddy_user,
    group   => $caddy::caddy_group,
    mode    => '0755',
    require => User[$caddy::caddy_user],
  }

  file {$caddy::caddy_log_dir:
    ensure  => directory,
    owner   => $caddy::caddy_user,
    group   => $caddy::caddy_group,
    mode    => '0755',
    require => User[$caddy::caddy_user],
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
    owner   => $caddy::caddy_user,
    group   => $caddy::caddy_group,
    source  => 'puppet:///modules/caddy/etc/caddy/Caddyfile',
    require => File['/etc/caddy'],
  }

  file {'/etc/caddy/config':
    ensure  => directory,
    purge   => true,
    recurse => true,
    mode    => '0755',
    owner   => $caddy::caddy_user,
    group   => $caddy::caddy_group,
    require => User[$caddy::caddy_user],
  }
}
