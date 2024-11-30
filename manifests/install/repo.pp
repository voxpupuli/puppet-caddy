# @summary
#   This class handles Caddy installation from a package repository
#
# @api private
#
class caddy::install::repo {
  assert_private()

  if $caddy::manage_repo and $caddy::repo_settings.length == 0 {
    fail("'repo_settings' parameter should be set when 'manage_repo' is true")
  }

  # Inject `before` into the repository settings
  $repo = $caddy::repo_settings + {
    before => Package[$caddy::package_name],
  }

  case $facts['os']['family'] {
    'Debian': {
      include apt

      if $caddy::manage_repo {
        # Use this when issues below are resolved
        # apt::source { 'caddy':
        #   * => $repo,
        # }

        # Below is a temporary workaround until
        # https://github.com/puppetlabs/puppetlabs-apt/issues/1196 is resolved.
        # dl.cloudsmith.io returns no headers Puppet can use to check if file
        # is changed.
        # Etag header is not supported, but discussed here:
        # https://github.com/puppetlabs/puppet/issues/9319
        # Checksum is not supported by apt::source's key nor by apt::keyring
        # resource. See https://github.com/puppetlabs/puppetlabs-apt/pull/1199

        if $repo.get('key.source') {
          $keyring_path = "/etc/apt/keyrings/${$repo.get('key.name')}"

          file { '/etc/apt/keyrings': ensure => 'directory' }

          file { $keyring_path:
            ensure         => 'file',
            source         => $repo.get('key.source'),
            checksum       => $repo.get('key.checksum', 'sha256'),
            checksum_value => $repo.get('key.checksum_value'),
            before         => Apt::Source['caddy'],
          }
        } else {
          $keyring_path = undef
        }

        # Drop 'key' from repo settings for now. Also, add `keyring`
        apt::source { 'caddy':
          * => $repo - 'key' + { 'keyring' => $keyring_path },
        }
      }
    }
    'RedHat': {
      include yum

      if $caddy::manage_repo {
        yum::copr { 'caddy':
          * => $repo,
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
