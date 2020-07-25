# @summary
#   This class handles the Caddy config.
#
# @api private
#
class caddy::config (
  $caddy_user    = $caddy::caddy_user,
  $caddy_group   = $caddy::caddy_group,
  $caddy_log_dir = $caddy::caddy_log_dir,
  $caddy_tmp_dir = $caddy::caddy_tmp_dir,
  $caddy_home    = $caddy::caddy_home,
  $caddy_ssl_dir = $caddy::caddy_ssl_dir,
) {
  assert_private()

  file {
    default:
      ensure => directory,
      owner  => $caddy_user,
      group  => $caddy_group,
      mode   => '0755',
      ;
    [$caddy_home,
      $caddy_ssl_dir,
      $caddy_log_dir,
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
