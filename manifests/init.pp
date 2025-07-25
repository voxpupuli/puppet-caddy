# @summary
#   Main class, includes all other classes.
#
# @example Basic usage
#   include caddy
#
# @example Install customized version of Caddy from the official site
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
#   Which version of caddy to install when install_method is github.
#   Must not be set otherwise.
#
# @param install_method
#   Which source to use for the Caddy installation. See https://caddyserver.com/docs/install.
#   * `github` - download from Github releases (version must be set in this case)
#   * `repo` - install from an OS repository
#   * `site` (default) - download from the official Caddy site
#
# @param install_path
#   Directory where the Caddy binary is stored. Not used when $install_method is 'repo'.
#
# @param manage_user
#   Whether or not the module should create the user.
#
# @param caddy_user
#   The user used by the Caddy process.
#
# @param manage_group
#    Whether or not the module should create the group.
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
# @param caddy_architecture
#    A temporary variable, required for the download URL.
#
# @param caddy_account_id
#   The account ID, required for the commercial license.
#
# @param caddy_api_key
#   The API key, required for the commercial license.
#
# @param manage_systemd_unit
#   Whether or not the module should create the systemd unit file.
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
# @param manage_service
#   Whether or not the module should manage the service.
#
# @param service_name
#   Customize the name of the system service.
#
# @param service_ensure
#   Whether the service should be running or stopped.
#
# @param service_enable
#   Whether the service should be enabled or disabled.
#
# @param manage_repo
#   Whether the APT/YUM(COPR) repository should be installed. Only relevant when $install_method is 'repo'.
#
# @param repo_settings
#   Distro-specific repository settings.
#
# @param package_name
#   Name of the caddy package to use. Only relevant when $install_method is 'repo'.
#
# @param package_ensure
#   Whether to install or remove the caddy package. Only relevant when $install_method is 'repo'.
#
# @param manage_caddyfile
#   Whether to manage Caddyfile.
#
# @param caddyfile_source
#   Caddyfile source.
#
# @param caddyfile_content
#   Caddyfile content.
#
# @param config_file_extension
#   Default extension for config and virtual host files (must include leading `.`)
#
# @param config_dir
#  Where to store Caddy configs.
#  Set this to /etc/caddy/conf-available to simulate nginx/apache behavior
#  (see config_enable_dir also).
#
# @param purge_config_dir
#  Whether to purge Caddy config directory.
#
# @param config_enable_dir
#  Where to load Caddy configs from. Set this parameter to /etc/caddy/conf-enabled
#  to simulate nginx/apache behavior.
#
# @param purge_config_enable_dir
#  Whether to purge Caddy enabled config directory.
#
# @param config_files
#   Hash of config files to create.
#
# @param vhost_dir
#  Where to store Caddy available virtual host configs. Set this to
#  /etc/caddy/vhost.d if you'd prefer to keep virtual hosts separated from
#  configs.
#  Set this to /etc/caddy/sites-available to simulate nginx/apache behavior
#  (see vhost_enable_dir also).
#
# @param purge_vhost_dir
#  Whether to purge Caddy available virtual host directory.
#
# @param vhost_enable_dir
#  Where to load Caddy virtual host configs from. Set this parameter to /etc/caddy/sites-enabled
#  to simulate nginx/apache behavior.
#
# @param purge_vhost_enable_dir
#  Whether to purge Caddy enabled virtual host directory.
#
# @param vhosts
#   Hash of virtual hosts to create.
#
class caddy (
  Optional[String[1]]            $package_ensure                  = undef,
  Optional[String[1]]            $version                         = undef,
  Enum['github', 'repo', 'site'] $install_method                  = 'site',
  Stdlib::Absolutepath           $install_path                    = '/opt/caddy',
  Boolean                        $manage_user                     = true,
  String[1]                      $caddy_user                      = 'caddy',
  Boolean                        $manage_group                    = true,
  String[1]                      $caddy_group                     = 'caddy',
  Stdlib::Absolutepath           $caddy_shell                     = '/sbin/nologin',
  Stdlib::Absolutepath           $caddy_log_dir                   = '/var/log/caddy',
  Stdlib::Absolutepath           $caddy_home                      = '/var/lib/caddy',
  Stdlib::Absolutepath           $caddy_ssl_dir                   = '/etc/ssl/caddy',
  Stdlib::Absolutepath           $config_dir                      = '/etc/caddy/config',
  Optional[Stdlib::Absolutepath] $config_enable_dir               = undef,
  Stdlib::Absolutepath           $vhost_dir                       = '/etc/caddy/config',
  Optional[Stdlib::Absolutepath] $vhost_enable_dir                = undef,
  Enum['personal', 'commercial'] $caddy_license                   = 'personal',
  Enum['on', 'off']              $caddy_telemetry                 = 'off',
  String[1]                      $caddy_features                  = 'http.git,http.filter,http.ipfilter',
  String[1]                      $caddy_architecture              = $facts['os']['architecture'],
  Optional[String[1]]            $caddy_account_id                = undef,
  Optional[String[1]]            $caddy_api_key                   = undef,
  Boolean                        $manage_systemd_unit             = true,
  Integer[0]                     $systemd_limit_processes         = 64,
  Boolean                        $systemd_private_devices         = true,
  Optional[String[1]]            $systemd_capability_bounding_set = undef,
  String[1]                      $systemd_ambient_capabilities    = 'CAP_NET_BIND_SERVICE',
  Optional[Boolean]              $systemd_no_new_privileges       = undef,
  Boolean                        $manage_service                  = true,
  String[1]                      $service_name                    = 'caddy',
  Stdlib::Ensure::Service        $service_ensure                  = 'running',
  Boolean                        $service_enable                  = true,
  Boolean                        $manage_repo                     = true,
  Hash[String[1],Any]            $repo_settings                   = {},
  String[1]                      $package_name                    = 'caddy',
  Boolean                        $manage_caddyfile                = true,
  Optional[Stdlib::Filesource]   $caddyfile_source                = undef,
  Optional[String[1]]            $caddyfile_content               = undef,
  Boolean                        $purge_config_dir                = true,
  Boolean                        $purge_config_enable_dir         = $purge_config_dir,
  Boolean                        $purge_vhost_dir                 = $purge_config_dir,
  Boolean                        $purge_vhost_enable_dir          = $purge_vhost_dir,
  Variant[Enum[''], Pattern[/^\./]]   $config_file_extension      = '.conf',
  Hash[String[1], Caddy::Config]      $config_files               = {},
  Hash[String[1], Caddy::VirtualHost] $vhosts                     = {},
) {
  case $caddy_architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'x86'            : { $arch = '386' }
    'aarch64'        : { $arch = 'arm64' }
    default:  {
      $arch = $caddy_architecture
      warning("arch ${arch} may not be supported.")
    }
  }

  if $manage_group {
    group { $caddy_group:
      ensure => present,
      system => true,
    }
  }

  if $manage_user {
    user { $caddy_user:
      ensure => present,
      shell  => $caddy_shell,
      gid    => $caddy_group,
      system => true,
      home   => $caddy_home,
    }

    if $manage_group {
      Group[$caddy_group] -> User[$caddy_user]
    }
  }

  contain caddy::install
  contain caddy::config
  contain caddy::service

  $config_files.each |String[1] $name, Caddy::Config $cfg| {
    caddy::configfile { $name:
      * => $cfg,
    }
  }

  $vhosts.each |String[1] $name, Caddy::VirtualHost $vhost| {
    caddy::vhost { $name:
      * => $vhost,
    }
  }

  Class['caddy::install']
  -> Class['caddy::config']
  ~> Class['caddy::service']
}
