# @summary
#   This class handles the Caddy archive.
#
# @api private
#
class caddy::install (
  $arch                  = $caddy::arch,
  $install_path          = $caddy::install_path,
  $caddy_tmp_dir         = $caddy::caddy_tmp_dir,
  $caddy_license         = $caddy::caddy_license,
  $caddy_account_id      = $caddy::caddy_account_id,
  $caddy_api_key         = $caddy::caddy_api_key,
  $caddy_telemetry       = $caddy::caddy_telemetry,
  $caddy_features        = $caddy::caddy_features,
  $caddy_private_devices = $caddy::caddy_private_devices,
  $caddy_limit_processes = $caddy::caddy_limit_processes,
) {

  assert_private()

  $caddy_url    = 'https://caddyserver.com/download/linux'
  $caddy_dl_url = "${caddy_url}/${arch}?plugins=${caddy_features}&license=${caddy_license}&telemetry=${caddy_telemetry}"
  $caddy_dl_dir = "${caddy_tmp_dir}/caddy_linux_${$arch}_custom.tar.gz"

  archive { $caddy_dl_dir:
    ensure       => present,
    extract      => true,
    extract_path => $install_path,
    source       => $caddy_dl_url,
    username     => $caddy_account_id,
    password     => $caddy_api_key,
    user         => 'root',
    group        => 'root',
    creates      => "${install_path}/caddy",
    cleanup      => true,
    notify       => File_capability["${install_path}/caddy"],
  }

  file_capability { "${install_path}/caddy":
    ensure     => present,
    capability => 'cap_net_bind_service=ep',
    require    => Archive[$caddy_dl_dir],
  }
}
