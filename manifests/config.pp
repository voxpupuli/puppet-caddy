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

    ['/etc/caddy/Caddyfile']:
      ensure  => file,
      mode    => '0444',
      source  => 'puppet:///modules/caddy/etc/caddy/Caddyfile',
      require => File['/etc/caddy'],
      ;

    ['/etc/caddy/config']:
      purge   => true,
      recurse => true,
      ;
  }
}
