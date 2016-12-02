# Class caddy::package
# ===========================
#
# Install required packages
#
class caddy::package (

  $install_path = $caddy::install_path,
  $caddy_features = $caddy::caddy_features,

){

  file { 'caddy_installer_script':
    ensure  => file,
    path    => '/tmp/caddy_installer_script.sh',
    content => template('caddy/caddy_installer_script.sh.erb'),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  exec { 'install caddy':
    command => "bash /tmp/caddy_installer_script.sh ${caddy_features}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    creates => "${install_path}/caddy",
    require => File['caddy_installer_script']
  }

  file { "${install_path}/caddy":
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Exec['install caddy']
  }

}
