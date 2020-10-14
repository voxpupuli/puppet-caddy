# @summary
#   This class handles the Caddy archive.
#
# @api private
#
class caddy::install (
  $arch             = $caddy::arch,
  $version          = $caddy::version,
  $install_method   = $caddy::install_method,
  $install_path     = $caddy::install_path,
  $caddy_user       = $caddy::caddy_user,
  $caddy_group      = $caddy::caddy_group,
  $caddy_tmp_dir    = $caddy::caddy_tmp_dir,
  $caddy_license    = $caddy::caddy_license,
  $caddy_account_id = $caddy::caddy_account_id,
  $caddy_api_key    = $caddy::caddy_api_key,
  $caddy_telemetry  = $caddy::caddy_telemetry,
  $caddy_features   = $caddy::caddy_features,
) {
  assert_private()

  if $version =~ /^1\./ {
    $dl_file_name = "caddy_v${version}_linux_${arch}.tar.gz"
  } else {
    $dl_file_name = "caddy_${version}_linux_${arch}.tar.gz"
  }

  case $install_method {
    'github': {
      $caddy_url    = 'https://github.com/caddyserver/caddy/releases/download'
      $caddy_dl_url = "${caddy_url}/v${version}/${dl_file_name}"
      $caddy_dl_dir = "${caddy_tmp_dir}/${dl_file_name}"
      $archive      = true
    }
    default: {
      $caddy_url    = 'https://caddyserver.com/api/download'
      $caddy_dl_url = "${caddy_url}?os=linux&arch=${arch}&plugins=${caddy_features}&license=${caddy_license}&telemetry=${caddy_telemetry}"
      $archive      = false
    }
  }

  file { $install_path:
    ensure => directory,
    owner  => $caddy_user,
    group  => $caddy_group,
    mode   => '0755',
  }

  if $archive {
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
      require      => File[$install_path],
    }
  } else {
    file { "${install_path}/caddy":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      source  => $caddy_dl_url,
      notify  => File_capability["${install_path}/caddy"],
      require => File[$install_path],
    }
  }

  include file_capability
  file_capability { "${install_path}/caddy":
    ensure     => present,
    capability => 'cap_net_bind_service=ep',
    require    => Archive[$caddy_dl_dir],
  }
}
