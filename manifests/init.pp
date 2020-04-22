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
  Optional[String[1]]            $caddy_account_id = undef,
  Optional[String[1]]            $caddy_api_key = undef,

  )
{
  case $facts['os']['architecture'] {
    'x86_64', 'amd64': { $arch = 'amd64'}
    'x86'            : { $arch = '386' }
    default:  {
      fail("${facts['os']['architecture']} is not supported.")
    }
  }

  include caddy::package
  include caddy::config
  include caddy::service
}
