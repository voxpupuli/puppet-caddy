# @summary
#   This defined type handles the Caddy virtual hosts.
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
  Optional[Stdlib::Filesource] $source  = undef,
  Optional[String]             $content = undef,
) {
  include caddy
  file { "/etc/caddy/config/${title}.conf":
    ensure  => file,
    content => $content,
    source  => $source,
    mode    => '0444',
    require => Class['caddy::config'],
    notify  => Class['caddy::service'],
  }
}
