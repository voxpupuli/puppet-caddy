# Class caddy::package
# ===========================
#
# Install required packages
#
class caddy::package inherits caddy {

  Exec {
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  }

  $caddy_url        = 'https://caddyserver.com/download/linux'
  $caddy_dl_url     = "${caddy_url}/${caddy::arch}?plugins=${caddy::caddy_features}&license=${caddy::caddy_license}&telemetry=${caddy::caddy_telemetry}"
  $caddy_dl_dir     = "${caddy::caddy_tmp_dir}/caddy_linux_${$caddy::arch}_custom.tar.gz"
  $caddy_dl_command = $caddy::caddy_license ? {
    'personal'   => "curl -o ${caddy_dl_dir} '${caddy_dl_url}'",
    'commercial' => "curl -o ${caddy_dl_dir} '${caddy_dl_url}' --user ${caddy::caddy_account_id}:${caddy::caddy_api_key}"
  }

  exec { 'install caddy':
    command => $caddy_dl_command,
    creates => "${caddy::install_path}/caddy",
  }

  exec { 'extract caddy':
    command => "tar -zxf ${caddy::caddy_tmp_dir}/caddy_linux_${$caddy::arch}_custom.tar.gz -C ${caddy::install_path} 'caddy'",
    creates => "${caddy::install_path}/caddy",
    require => Exec['install caddy'],
  }

  file { "${caddy::install_path}/caddy":
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Exec['extract caddy'],
    notify  => Exec['set cap caddy'],
  }

  exec { 'set cap caddy':
    command     => "setcap cap_net_bind_service=+ep ${caddy::install_path}/caddy",
    require     => File["${caddy::install_path}/caddy"],
    refreshonly => true,
  }

}
