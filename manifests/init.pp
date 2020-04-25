# Class: caddy
# ===========================
#
# Examples
# --------
#
# ```puppet
# include caddy
# ```
#
# Install caddy with additiional features
#
# ```puppet
# class {'caddy':
#   caddy_features = "http.filter,http.git,http.ipfilter",
# }
# ```
#
# Authors
# -------
#
# Lukasz Rohde <kujon447@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Lukasz Rohde.
#
class caddy (

  Stdlib::Absolutepath           $install_path = '/usr/local/bin',
  String                         $caddy_user = 'caddy',
  String                         $caddy_group = 'caddy',
  Stdlib::Absolutepath           $caddy_log_dir = '/var/log/caddy',
  Stdlib::Absolutepath           $caddy_tmp_dir = '/tmp',
  Stdlib::Absolutepath           $caddy_home = '/etc/ssl/caddy',
  Stdlib::Absolutepath           $caddy_ssl_dir = "${caddy_home}/.caddy",
  Enum['personal', 'commercial'] $caddy_license = 'personal',
  Enum['on','off']               $caddy_telemetry = 'off',
  String                         $caddy_features = 'http.filter,http.git,http.ipfilter',
  Stdlib::Port                   $caddy_http_port = 80,
  Stdlib::Port                   $caddy_https_port = 443,
  Boolean                        $caddy_private_devices = true,
  Integer                        $caddy_limit_processes = 64,
  String                         $caddy_architecture = $facts['os']['architecture'],
  Optional[String[1]]            $caddy_account_id = undef,
  Optional[String[1]]            $caddy_api_key = undef,

  )
{
  case $caddy_architecture {
    'x86_64', 'amd64': { $arch = 'amd64'}
    'x86'            : { $arch = '386' }
    default:  {
      $arch = $caddy_architecture
      warning("arch ${arch} may not be supported.")
    }
  }

  group { $caddy::caddy_group:
    ensure => present,
    system => true,
  }

  user { $caddy::caddy_user:
    ensure     => present,
    shell      => '/sbin/nologin',
    gid        => $caddy::caddy_group,
    system     => true,
    home       => $caddy::caddy_home,
    managehome => true,
  }

  contain caddy::package
  contain caddy::config
  contain caddy::service

  Class['caddy::package']
  -> Class['caddy::config']
  ~> Class['caddy::service']
}
