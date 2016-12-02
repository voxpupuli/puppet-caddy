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
  $source  = undef,
  $content = undef,
  $caddy_user = $caddy::caddy_user,
) {


  file { "/etc/caddy/config/${title}.conf":
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => $caddy_user,
    group   => $caddy_user,
    mode    => '0444',
    require => Class['caddy::config'],
    notify  => Class['caddy::service'],
  }
}
