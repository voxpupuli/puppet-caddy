# Class caddy::package
# ===========================
#
# Install required packages
#
class caddy::package inherits caddy {

  Exec {
    path => '/sbin:/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  }

  case $caddy::install_method {
    'github': {
      $caddy_url        = 'https://github.com/mholt/caddy/releases/download'
      $caddy_dl_url     = "${caddy_url}/v${caddy::params::version}/caddy_v${caddy::params::version}_linux_${caddy::params::arch}.tar.gz"
      $caddy_dl_name    = "caddy_v${caddy::params::version}_linux_${caddy::params::arch}.tar.gz"
      $caddy_dl_dir     = "${caddy::params::caddy_tmp_dir}/${caddy_dl_name}"
      $caddy_dl_command = "curl -s -L -o ${caddy_dl_dir} '${caddy_dl_url}'"
    }
    default: {
      $caddy_url        = 'https://caddyserver.com/download/linux'
      $caddy_dl_url     = "${caddy_url}/${caddy::params::arch}?plugins=${caddy::caddy_features}&license=${caddy::caddy_license}&telemetry=${caddy::caddy_telemetry}"
      $caddy_dl_name    = "caddy_linux_${caddy::params::arch}_custom.tar.gz"
      $caddy_dl_dir     = "${caddy::params::caddy_tmp_dir}/${caddy_dl_name}"
      $caddy_dl_command = $caddy::params::caddy_license ? {
        'personal'   => "curl -s -o ${caddy_dl_dir} '${caddy_dl_url}'",
        'commercial' => "curl -s -o ${caddy_dl_dir} '${caddy_dl_url}' --user ${caddy::params::caddy_account_id}:${caddy::params::caddy_api_key}"
      }
    }
  }

  exec { 'install caddy':
    command => $caddy_dl_command,
    creates => "${caddy::install_path}/caddy",
  }

  exec { 'extract caddy':
    command => "tar -zxf ${caddy::params::caddy_tmp_dir}/${caddy_dl_name} -C ${caddy::install_path} 'caddy'",
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
