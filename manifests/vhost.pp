# Defione: caddy::vhost
# ===========================
#
# Setup caddy vhost in /etc/caddy/config/
#
# Examples:
# ---------
#
# caddy::vhost {'example1':
#   source => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
# }
#
#
define caddy::vhost(
  $source     = undef,
  $content    = undef,
) {

  file { "/etc/caddy/config/${title}.conf":
    ensure  => file,
    content => $content,
    source  => $source,
    mode    => '0444',
    require => Class['caddy::config'],
    notify  => Class['caddy::service'],
  }
}
