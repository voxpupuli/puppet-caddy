# @summary
#   This class handles the Caddy service.
#
# @api private
#
class caddy::service {
  assert_private()

  # Do not manage unit file if install_method is repo
  if $caddy::manage_systemd_unit and $caddy::install_method != 'repo' {
    $notify_service_maybe = $caddy::manage_service ? {
      true    => Service[$caddy::service_name],
      default => undef,
    }

    systemd::unit_file { "${caddy::service_name}.service":
      content => epp('caddy/etc/systemd/system/caddy.service.epp',
        {
          install_path                    => $caddy::install_path,
          caddy_user                      => $caddy::caddy_user,
          caddy_group                     => $caddy::caddy_group,
          caddy_log_dir                   => $caddy::caddy_log_dir,
          caddy_ssl_dir                   => $caddy::caddy_ssl_dir,
          caddy_home                      => $caddy::caddy_home,
          systemd_limit_processes         => $caddy::systemd_limit_processes,
          systemd_private_devices         => $caddy::systemd_private_devices,
          systemd_capability_bounding_set => $caddy::systemd_capability_bounding_set,
          systemd_ambient_capabilities    => $caddy::systemd_ambient_capabilities,
          systemd_no_new_privileges       => $caddy::systemd_no_new_privileges,
        }
      ),
      notify  => $notify_service_maybe,
    }
  }

  if $caddy::manage_service {
    service { $caddy::service_name:
      ensure => $caddy::service_ensure,
      enable => $caddy::service_enable,
    }
  }
}
