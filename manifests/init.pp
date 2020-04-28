# @summary
#   Main class, includes all other classes.
#
# @example Basic usage
#   include caddy
#
# @example Install Caddy with additional features
#   class { 'caddy':
#     caddy_features => 'http.git, http.filter, http.ipfilter',
#   }
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
# @param caddy_private_device
#   Whether physical devices are turned off.
#
# @param caddy_limit_processes
#   The maximum number of Caddy processes.
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
class caddy (
  Stdlib::Absolutepath           $install_path          = '/usr/local/bin',
  String[1]                      $caddy_user            = 'caddy',
  String[1]                      $caddy_group           = 'caddy',
  Stdlib::Absolutepath           $caddy_log_dir         = '/var/log/caddy',
  Stdlib::Absolutepath           $caddy_tmp_dir         = '/tmp',
  Stdlib::Absolutepath           $caddy_home            = '/etc/ssl/caddy',
  Stdlib::Absolutepath           $caddy_ssl_dir         = "${caddy_home}/.caddy",
  Enum['personal', 'commercial'] $caddy_license         = 'personal',
  Enum['on','off']               $caddy_telemetry       = 'off',
  String[1]                      $caddy_features        = 'http.filter,http.git,http.ipfilter',
  Stdlib::Port                   $caddy_http_port       = 80,
  Stdlib::Port                   $caddy_https_port      = 443,
  Boolean                        $caddy_private_devices = true,
  Integer[0]                     $caddy_limit_processes = 64,
  String[1]                      $caddy_architecture    = $facts['os']['architecture'],
  Optional[String[1]]            $caddy_account_id      = undef,
  Optional[String[1]]            $caddy_api_key         = undef,
) {
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

  contain caddy::install
  contain caddy::config
  contain caddy::service

  Class['caddy::install']
  -> Class['caddy::config']
  ~> Class['caddy::service']
}
