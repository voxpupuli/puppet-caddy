# @summary
#   Main class, includes all other classes.
#
# @example Basic usage
#   include caddy
#
# @example Install customised version of Caddy
#   class { 'caddy':
#     caddy_features => 'http.git,http.filter,http.ipfilter',
#   }
#
# @example Install specific version of Caddy
#   class { 'caddy':
#     version        => '2.0.0',
#     install_method => 'github',
#   }
#
# @param version
#   Which version is used.
#
# @param install_method
#   Which source is used.
#
# @param install_path
#   Directory where the Caddy binary is stored.
#
# @param caddy_user
#   The user used by the Caddy process.
#
# @param caddy_group
#   The group used by the Caddy process.
#
# @param caddy_shell
#   Which shell is used.
#
# @param caddy_log_dir
#   Directory where the log files are stored.
#
# @param caddy_tmp_dir
#   Directory where the Caddy archive is stored.
#
# @param caddy_home
#   Directory where the Caddy data is stored.
#
# @param caddy_ssl_dir
#   Directory where Let's Encrypt certificates are stored.
#
# @param caddy_license
#   Whether a personal or commercial license is used.
#
# @param caddy_telemetry
#   Whether telemetry data should be collected.
#
# @param caddy_features
#   A list of features the Caddy binary should support.
#
# @param caddy_http_port
#   Which port for HTTP is used.
#
# @param caddy_https_port
#   Which port for HTTPS is used.
#
# @param caddy_architecture
#    A temporary variable, required for the download URL.
#
# @param caddy_account_id
#   The account ID, required for the commercial license.
#
# @param caddy_api_key
#   The API key, required for the commercial license.
#
# @param systemd_limit_processes
#   The number of processes.
#
# @param systemd_private_devices
#   Whether the process has access to physical devices.
#
# @param systemd_capability_bounding_set
#   Controls which capabilities to include in the capability bounding set for the executed process.
#
# @param systemd_ambient_capabilities
#   Controls which capabilities to include in the ambient capability set for the executed process.
#
# @param systemd_no_new_privileges
#   Whether the process and all its children can gain new privileges through execve().
#
class caddy (
  String[1]                      $version                         = '2.0.0',
  Optional[Enum['github']]       $install_method                  = undef,
  Stdlib::Absolutepath           $install_path                    = '/opt/caddy',
  String[1]                      $caddy_user                      = 'caddy',
  String[1]                      $caddy_group                     = 'caddy',
  Stdlib::Absolutepath           $caddy_shell                     = '/sbin/nologin',
  Stdlib::Absolutepath           $caddy_log_dir                   = '/var/log/caddy',
  Stdlib::Absolutepath           $caddy_tmp_dir                   = '/tmp',
  Stdlib::Absolutepath           $caddy_home                      = '/var/lib/caddy',
  Stdlib::Absolutepath           $caddy_ssl_dir                   = '/etc/ssl/caddy',
  Enum['personal', 'commercial'] $caddy_license                   = 'personal',
  Enum['on','off']               $caddy_telemetry                 = 'off',
  String[1]                      $caddy_features                  = 'http.git,http.filter,http.ipfilter',
  Stdlib::Port                   $caddy_http_port                 = 80,
  Stdlib::Port                   $caddy_https_port                = 443,
  String[1]                      $caddy_architecture              = $facts['os']['architecture'],
  Optional[String[1]]            $caddy_account_id                = undef,
  Optional[String[1]]            $caddy_api_key                   = undef,
  Integer[0]                     $systemd_limit_processes         = 64,
  Boolean                        $systemd_private_devices         = true,
  Optional[String[1]]            $systemd_capability_bounding_set = undef,
  Optional[String[1]]            $systemd_ambient_capabilities    = undef,
  Optional[Boolean]              $systemd_no_new_privileges       = undef,
) {
  case $caddy_architecture {
    'x86_64', 'amd64': { $arch = 'amd64'}
    'x86'            : { $arch = '386' }
    default:  {
      $arch = $caddy_architecture
      warning("arch ${arch} may not be supported.")
    }
  }

  group { $caddy_group:
    ensure => present,
    system => true,
  }

  user { $caddy_user:
    ensure => present,
    shell  => $caddy_shell,
    gid    => $caddy_group,
    system => true,
    home   => $caddy_home,
  }

  contain caddy::install
  contain caddy::config
  contain caddy::service

  Class['caddy::install']
  -> Class['caddy::config']
  ~> Class['caddy::service']
}
