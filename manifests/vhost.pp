# @summary This defined type handles a Caddy virtual host
#
# @param ensure
#   Make the vhost either present (same as disabled), enabled, disabled or absent.
#
# @param source
#   Source (path) for the caddy vhost configuration.
#
# @param content
#   String with the caddy vhost configuration.
#
# @param config_dir
#   Where to store the vhost config file.
#
# @param enable_dir
#   Directory to symlink the vhost config file into (sites-enabled e.g.) if any.
#
# @param file_extension
#   Default extension for the vhost config file (must include leading `.`)
#
# @example Configure virtual host, based on source
#   caddy::vhost { 'example1':
#     source => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
#   }
#
# @example Configure virtual host, based on content
#   caddy::vhost { 'example2:
#     content => 'localhost:2015',
#   }
#
define caddy::vhost (
  Enum['present','enabled','disabled','absent'] $ensure = 'enabled',
  Optional[Stdlib::Filesource] $source = undef,
  Optional[String] $content = undef,
  Stdlib::Absolutepath $config_dir = $caddy::vhost_dir,
  Optional[Stdlib::Absolutepath] $enable_dir = $caddy::vhost_enable_dir,
  Variant[Enum[''], Pattern[/^\./]] $file_extension = $caddy::config_file_extension,
) {
  include caddy

  if ($ensure != 'absent') and !($source or $content) {
    fail('Either $source or $content must be specified when $ensure is "present"')
  }

  $file_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }

  $filename = "${title}${file_extension}"

  file { "${config_dir}/${filename}":
    ensure  => $file_ensure,
    content => $content,
    source  => $source,
    mode    => '0444',
    require => Class['caddy::config'],
    notify  => Class['caddy::service'],
  }

  if $enable_dir {
    $symlink_ensure = $ensure ? {
      'enabled' => 'link',
      default   => 'absent',
    }

    file { "${enable_dir}/${filename}":
      ensure  => $symlink_ensure,
      target  => "${config_dir}/${filename}",
      require => Class['caddy::config'],
      notify  => Class['caddy::service'],
    }
  }
}
