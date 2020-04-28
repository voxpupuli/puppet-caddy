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
#     version        => '1.0.3',
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
  String[1]                      $version                         = '1.0.4',
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

  include file_capability

  case $caddy_architecture {
    'x86_64', 'amd64': { $arch = 'amd64'}
    'x86'            : { $arch = '386' }
    default:  {
      $arch = $caddy_architecture
      warning("arch ${arch} may not be supported.")
    }
  }

  case $install_method {
    'github': {
      $caddy_url    = 'https://github.com/caddyserver/caddy/releases/download'
      $caddy_dl_url = "${caddy_url}/v${version}/caddy_v${version}_linux_${arch}.tar.gz"
      $caddy_dl_dir = "${caddy_tmp_dir}/caddy_v${version}_linux_${$arch}.tar.gz"
    }
    default: {
      $caddy_url    = 'https://caddyserver.com/download/linux'
      $caddy_dl_url = "${caddy_url}/${arch}?plugins=${caddy_features}&license=${caddy_license}&telemetry=${caddy_telemetry}"
      $caddy_dl_dir = "${caddy_tmp_dir}/caddy_linux_${$arch}_custom.tar.gz"
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

  file { $install_path:
    ensure => directory,
    owner  => $caddy_user,
    group  => $caddy_group,
    mode   => '0755',
  }

  archive { $caddy_dl_dir:
    ensure       => present,
    extract      => true,
    extract_path => $install_path,
    source       => $caddy_dl_url,
    username     => $caddy_account_id,
    password     => $caddy_api_key,
    user         => 'root',
    group        => 'root',
    creates      => "${install_path}/caddy",
    cleanup      => true,
    notify       => File_capability["${install_path}/caddy"],
    require      => File[$install_path],
  }

  file_capability { "${install_path}/caddy":
    ensure     => present,
    capability => 'cap_net_bind_service=ep',
    require    => Archive[$caddy_dl_dir],
  }

  file { $caddy_home:
    ensure  => directory,
    owner   => $caddy_user,
    group   => $caddy_group,
    mode    => '0755',
    require => Archive[$caddy_dl_dir],
    notify  => Service['caddy'],
  }

  file { $caddy_ssl_dir:
    ensure  => directory,
    owner   => $caddy_user,
    group   => $caddy_group,
    mode    => '0755',
    require => Archive[$caddy_dl_dir],
    notify  => Service['caddy'],
  }

  file { $caddy_log_dir:
    ensure  => directory,
    owner   => $caddy_user,
    group   => $caddy_group,
    mode    => '0755',
    require => Archive[$caddy_dl_dir],
    notify  => Service['caddy'],
  }

  file { '/etc/caddy':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Archive[$caddy_dl_dir],
    notify  => Service['caddy'],
  }

  file { '/etc/caddy/Caddyfile':
    ensure  => file,
    owner   => $caddy_user,
    group   => $caddy_group,
    mode    => '0444',
    content => file('caddy/Caddyfile'),
    require => Archive[$caddy_dl_dir],
    notify  => Service['caddy'],
  }

  file { '/etc/caddy/config':
    ensure  => directory,
    purge   => true,
    recurse => true,
    owner   => $caddy_user,
    group   => $caddy_group,
    mode    => '0755',
    require => Archive[$caddy_dl_dir],
    notify  => Service['caddy'],
  }

  case $facts['service_provider'] {
    default:  {
      fail("service provider ${$facts['service_provider']} is not supported.")
    }
    'systemd': {
      systemd::unit_file { 'caddy.service':
        content => epp('caddy/caddy.service.epp',
          {
            install_path                    => $install_path,
            caddy_user                      => $caddy_user,
            caddy_group                     => $caddy_group,
            caddy_log_dir                   => $caddy_log_dir,
            caddy_ssl_dir                   => $caddy_ssl_dir,
            caddy_home                      => $caddy_home,
            caddy_http_port                 => $caddy_http_port,
            caddy_https_port                => $caddy_https_port,
            systemd_limit_processes         => $systemd_limit_processes,
            systemd_private_devices         => $systemd_private_devices,
            systemd_capability_bounding_set => $systemd_capability_bounding_set,
            systemd_ambient_capabilities    => $systemd_ambient_capabilities,
            systemd_no_new_privileges       => $systemd_no_new_privileges,
          }
        ),
        notify  => Service['caddy'],
      }
    }
    'redhat': {
      file { '/etc/init.d/caddy':
        ensure  => file,
        content => epp('caddy/caddy.epp',
          {
            caddy_user    => $caddy_user,
            caddy_log_dir => $caddy_log_dir,
            caddy_ssl_dir => $caddy_ssl_dir,
            caddy_home    => $caddy_home,
          }
        ),
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        notify  => Service['caddy'],
      }
    }
  }

  service { 'caddy':
    ensure => running,
    enable => true,
  }
}
