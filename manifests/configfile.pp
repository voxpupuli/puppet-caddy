# @summary This defined type handles a Caddy config file
#
# @param ensure
#   Make the config file either present (same as disabled), enabled, disabled or absent.
#
# @param source
#   Source (path) for the caddy config file.
#
# @param content
#   String with the caddy config file.
#
# @param config_dir
#   Where to store the config file.
#
# @param enable_dir
#   Directory to symlink the config config file into (conf-enabled e.g.) if any.
#
# @param file_extension
#   Default extension for the config file (must include leading `.`)
#
# @example Configure Caddy logging
#   caddy::configfile { 'subdomain-log':
#     source => 'puppet:///modules/caddy/etc/caddy/config/logging.conf',
#   }
#
# @example Same as above but using content
#   $log_config = @(SUBDOMAIN_LOG)
#     (subdomain-log) {
#       log {
#         hostnames {args[0]}
#         output file /var/log/caddy/{args[0]}.log
#       }
#     }
#     | SUBDOMAIN_LOG
#
#   caddy::configfile { 'subdomain-log':
#     content => $log_config,
#   }
#
define caddy::configfile (
  Enum['present','enabled','disabled','absent'] $ensure = 'enabled',
  Optional[Stdlib::Filesource] $source = undef,
  Optional[String] $content = undef,
  Stdlib::Absolutepath $config_dir = $caddy::config_dir,
  Optional[Stdlib::Absolutepath] $enable_dir = $caddy::config_enable_dir,
  Variant[Enum[''], Pattern[/^\./]] $file_extension = $caddy::config_file_extension,
) {
  include caddy

  if ($ensure != 'absent') and !($source or $content) {
    fail('Either $source or $content must be specified when $ensure is "present"')
  }

  $file_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }

  $filename = "${title}${file_extension}"

  file { "${config_dir}/${filename}":
    ensure  => $file_ensure,
    content => $content,
    source  => $source,
    mode    => '0444',
    require => Class['caddy::config'],
    notify  => Class['caddy::service'],
  }

  if $enable_dir {
    $symlink_ensure = $ensure ? {
      'enabled' => 'link',
      default   => 'absent',
    }

    file { "${enable_dir}/${filename}":
      ensure  => $symlink_ensure,
      target  => "${config_dir}/${filename}",
      require => Class['caddy::config'],
      notify  => Class['caddy::service'],
    }
  }
}
