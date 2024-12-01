# @summary
#   This class handles Caddy installation from a package repository
#
# @api private
#
class caddy::install::repo {
  assert_private()

  case $facts['os']['family'] {
    'Debian': {
      include apt

      if $caddy::manage_repo {
        apt::source { 'caddy':
          location => "https://dl.cloudsmith.io/public/caddy/${caddy::distribution_channel}/deb/debian",
          release  => 'any-version',
          repos    => 'main',
          key      => {
            name   => "caddy-${caddy::distribution_channel}-archive-keyring.asc",
            source => "https://dl.cloudsmith.io/public/caddy/${caddy::distribution_channel}/gpg.key",
          },
          before   => Package[$caddy::package_name],
        }
      }
    }
    'RedHat': {
      include yum

      if $caddy::manage_repo {
        yum::copr { '@caddy/caddy':
          ensure => 'enabled',
          before => Package[$caddy::package_name],
        }
      }
    }
    default: {
      fail("OS family ${facts['os']['family']} has no support for 'repo' install method")
    }
  }

  package { $caddy::package_name:
    ensure => $caddy::package_ensure.lest || { 'installed' },
  }
}
