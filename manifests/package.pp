# Class caddy::package
# ===========================
#
# Install required packages
#
class caddy::package inherits caddy {

  Exec {
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  }

  $caddy_url    = 'https://caddyserver.com/download/linux'
  $caddy_dl_url = "${caddy_url}/${$caddy::params::arch}?plugins=${caddy::caddy_features}"
  $caddy_dl_dir = "${caddy::params::caddy_tmp_dir}/caddy_linux_${$caddy::params::arch}_custom.tar.gz"

  exec { 'install caddy':
    command => "curl -o ${caddy_dl_dir} ${caddy_dl_url}",
    creates => "${caddy::install_path}/caddy",
  }

  exec { 'extract caddy':
    command => "tar -zxf ${caddy::params::caddy_tmp_dir}/caddy_linux_${$caddy::params::arch}_custom.tar.gz -C ${caddy::install_path} 'caddy'",
    creates => "${caddy::install_path}/caddy",
    require => Exec['install caddy'],
  }

  file { "${caddy::install_path}/caddy":
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Exec['extract caddy'],
  }

}
