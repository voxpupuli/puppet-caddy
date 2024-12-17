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
    $caddy::config_dir:
      purge   => $caddy::purge_config_dir,
      recurse => true,
      ;
  }

  if $caddy::manage_caddyfile {
    # Prefer source over content if both are defined
    # Fallback to the bundled template if both are unset
    $real_source  = $caddy::caddyfile_source
    $real_content = if $caddy::caddyfile_source { undef } else {
      $caddy::caddyfile_content.lest || {
        epp('caddy/etc/caddy/caddyfile.epp',
          config_dir => $caddy::config_dir,
        )
      }
    }

    file { '/etc/caddy/Caddyfile':
      ensure  => file,
      mode    => '0444',
      owner   => $caddy::caddy_user,
      group   => $caddy::caddy_group,
      source  => $real_source,
      content => $real_content,
    }
  }
}
