# @summary
#   This class handles Caddy installation from the official site
#
# @api private
#
class caddy::install::site {
  assert_private()

  $bin_file = $caddy::install::bin_file

  $query_params = {
    os        => 'linux',
    arch      => $caddy::arch,
    plugins   => $caddy::caddy_features,
    license   => $caddy::caddy_license,
    telemetry => $caddy::caddy_telemetry,
  }.map |$k, $v| { "${k}=${v}" }.join('&')

  $caddy_source = '/var/cache/caddy-latest'
  $caddy_dl_url    = "https://caddyserver.com/api/download?${query_params}"

  file { $caddy_source:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => $caddy_dl_url,
    replace => false, # Don't download the file on every run
  }

  file { $caddy::install_path:
    ensure => directory,
    owner  => $caddy::caddy_user,
    group  => $caddy::caddy_group,
    mode   => '0755',
  }

  file { $bin_file:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => $caddy_source,
  }
}
