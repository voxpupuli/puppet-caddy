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

  String                         $install_path,
  String                         $caddy_user,
  String                         $caddy_group,
  String                         $caddy_log_dir,
  String                         $caddy_tmp_dir,
  String                         $caddy_ssl_dir,
  String                         $caddy_home,
  Enum['personal', 'commercial'] $caddy_license,
  Enum['on','off']               $caddy_telemetry,
  String                         $caddy_features,
  Stdlib::Port                   $caddy_http_port,
  Stdlib::Port                   $caddy_https_port,
  Boolean                        $caddy_private_devices,
  Integer                        $caddy_limit_processes,
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
