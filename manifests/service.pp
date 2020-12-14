# @summary
#   This class handles the Caddy service.
#
# @api private
#
class caddy::service (
  $install_path                    = $caddy::install_path,
  $caddy_user                      = $caddy::caddy_user,
  $caddy_group                     = $caddy::caddy_group,
  $caddy_log_dir                   = $caddy::caddy_log_dir,
  $caddy_ssl_dir                   = $caddy::caddy_ssl_dir,
  $caddy_home                      = $caddy::caddy_home,
  $caddy_http_port                 = $caddy::caddy_http_port,
  $caddy_https_port                = $caddy::caddy_https_port,
  $systemd_limit_processes         = $caddy::systemd_limit_processes,
  $systemd_private_devices         = $caddy::systemd_private_devices,
  $systemd_capability_bounding_set = $caddy::systemd_capability_bounding_set,
  $systemd_ambient_capabilities    = $caddy::systemd_ambient_capabilities,
  $systemd_no_new_privileges       = $caddy::systemd_no_new_privileges,
) {
  assert_private()

  systemd::unit_file { 'caddy.service':
    enable  => true,
    active  => true,
    content => epp('caddy/etc/systemd/system/caddy.service.epp',
      {
        install_path                    => $install_path,
        caddy_user                      => $caddy_user,
        caddy_group                     => $caddy_group,
        caddy_log_dir                   => $caddy_log_dir,
        caddy_ssl_dir                   => $caddy_ssl_dir,
        caddy_home                      => $caddy_home,
        caddy_http_port                 => $caddy_http_port,
        caddy_https_port                => $caddy_https_port,
        systemd_limit_processes         => $systemd_limit_processes,
        systemd_private_devices         => $systemd_private_devices,
        systemd_capability_bounding_set => $systemd_capability_bounding_set,
        systemd_ambient_capabilities    => $systemd_ambient_capabilities,
        systemd_no_new_privileges       => $systemd_no_new_privileges,
      }
    ),
  }
}
