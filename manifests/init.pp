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

  String                         $install_path          = $caddy::params::install_path,
  String                         $caddy_user            = $caddy::params::caddy_user,
  String                         $caddy_group           = $caddy::params::caddy_group,
  String                         $caddy_log_dir         = $caddy::params::caddy_log_dir,
  String                         $caddy_tmp_dir         = $caddy::params::caddy_tmp_dir,
  String                         $caddy_ssl_dir         = $caddy::params::caddy_ssl_dir,
  String                         $caddy_home            = $caddy::params::caddy_home,
  Enum['personal', 'commercial'] $caddy_license         = $caddy::params::caddy_license,
  Optional[String[1]]            $caddy_account_id      = $caddy::params::caddy_account_id,
  Optional[String[1]]            $caddy_api_key         = $caddy::params::caddy_api_key,
  Enum['on','off']               $caddy_telemetry       = $caddy::params::caddy_telemetry,
  String                         $caddy_features        = $caddy::params::caddy_features,
  Stdlib::Port                   $caddy_http_port       = $caddy::params::caddy_http_port,
  Stdlib::Port                   $caddy_https_port      = $caddy::params::caddy_https_port,
  Boolean                        $caddy_private_devices = $caddy::params::caddy_private_devices,
  Integer                        $caddy_limit_processes = $caddy::params::caddy_limit_processes,

  )inherits caddy::params{

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

  include caddy::package
  include caddy::config
  include caddy::service
}
