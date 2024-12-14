# @summary This defined type handles the Caddy virtual hosts.
#
# @param ensure
#   Make the vhost either present or absent
# @param source
#   Source (path) for the caddy vhost configuration
# @param content
#   String with the caddy vhost configuration
#
# @example Configure virtual host, based on source
#   caddy::vhost { 'example1':
#     source => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
#   }
#
# @example Configure virtual host, based on content
#   caddy::vhost { 'example2:
#     content => 'localhost:2015',
#   }
#
define caddy::vhost (
  Enum['present','absent']     $ensure  = 'present',
  Optional[Stdlib::Filesource] $source  = undef,
  Optional[String]             $content = undef,
) {
  include caddy
  file { "/etc/caddy/config/${title}.conf":
    ensure  => stdlib::ensure($ensure, 'file'),
    content => $content,
    source  => $source,
    mode    => '0444',
    require => Class['caddy::config'],
    notify  => Class['caddy::service'],
  }
}
