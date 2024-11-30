# @summary
#   This class handles the Caddy archive.
#
# @api private
#
class caddy::install {
  assert_private()

  $bin_file = "${caddy::install_path}/caddy"

  case $caddy::install_method {
    'github': {
      $caddy_url    = 'https://github.com/caddyserver/caddy/releases/download'
      $caddy_dl_url = "${caddy_url}/v${caddy::version}/caddy_${caddy::version}_linux_${caddy::arch}.tar.gz"
      $caddy_dl_dir = "/var/cache/caddy_${caddy::version}_linux_${$caddy::arch}.tar.gz"

      $extract_path = "/var/cache/caddy-${caddy::version}"

      file { $extract_path:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      archive { $caddy_dl_dir:
        ensure       => present,
        extract      => true,
        extract_path => $extract_path,
        source       => $caddy_dl_url,
        username     => $caddy::caddy_account_id,
        password     => $caddy::caddy_api_key,
        user         => 'root',
        group        => 'root',
        creates      => "${extract_path}/caddy",
        require      => File[$extract_path],
        before       => File[$bin_file],
      }

      $caddy_source = "/var/cache/caddy-${caddy::version}/caddy"
    }
    default: {
      $caddy_url    = 'https://caddyserver.com/api/download'
      $query_params = {
        os        => 'linux',
        arch      => $caddy::arch,
        plugins   => $caddy::caddy_features,
        license   => $caddy::caddy_license,
        telemetry => $caddy::caddy_telemetry,
      }.map |$k, $v| { "${k}=${v}" }.join('&')

      $caddy_dl_url = "${caddy_url}?${query_params}"

      $caddy_source = '/var/cache/caddy-latest'

      file { $caddy_source:
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => $caddy_dl_url,
        replace => false, # Don't download the file on every run
      }
    }
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
