# @summary This defined type handles a Caddy config file
#
# @param ensure
#   Make the config file either present or absent.
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
  Enum['present','absent'] $ensure = 'present',
  Optional[Stdlib::Filesource] $source = undef,
  Optional[String] $content = undef,
  Stdlib::Absolutepath $config_dir = $caddy::config_dir,
) {
  include caddy

  if ($ensure == 'present') and !($source or $content) {
    fail('Either $source or $content must be specified when $ensure is "present"')
  }

  file { "${config_dir}/${title}.conf":
    ensure  => stdlib::ensure($ensure, 'file'),
    content => $content,
    source  => $source,
    mode    => '0444',
    require => Class['caddy::config'],
    notify  => Class['caddy::service'],
  }
}
