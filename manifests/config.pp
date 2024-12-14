# @summary
#   This class handles the Caddy config.
#
# @api private
#
class caddy::config {
  assert_private()

  file {
    default:
      ensure => directory,
      owner  => $caddy::caddy_user,
      group  => $caddy::caddy_group,
      mode   => '0755',
      ;
    [$caddy::caddy_home,
      $caddy::caddy_ssl_dir,
      $caddy::caddy_log_dir,
    ]:
      ;
    ['/etc/caddy']:
      owner => 'root',
      group => 'root',
      ;
    ['/etc/caddy/config']:
      purge   => true,
      recurse => true,
      ;
  }

  if $caddy::manage_caddyfile {
    # caddyfile_content is always preferred over caddyfile_source when set
    file { '/etc/caddy/Caddyfile':
      ensure  => file,
      mode    => '0444',
      owner   => $caddy::caddy_user,
      group   => $caddy::caddy_group,
      source  => if $caddy::caddyfile_content { undef } else { $caddy::caddyfile_source },
      content => $caddy::caddyfile_content,
    }
  }
}
