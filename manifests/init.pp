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
  Optional[String[1]]            $caddy_account_id,
  Optional[String[1]]            $caddy_api_key,
  Enum['on','off']               $caddy_telemetry,
  String                         $caddy_features,
  Stdlib::Port                   $caddy_http_port,
  Stdlib::Port                   $caddy_https_port,
  Boolean                        $caddy_private_devices,
  Integer                        $caddy_limit_processes,
) {
  case $facts['architecture'] {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'x86', 'i386':     { $arch = '386'   }
    default:           {
      fail("${facts['architecture']} is not supported.")
    }
  }

  contain caddy::package
  contain caddy::config
  contain caddy::service

  Class['caddy::package']
  -> Class['caddy::config']
  ~> Class['caddy::service']
}
