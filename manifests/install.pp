# @summary
#   This class handles the Caddy archive.
#
# @api private
#
class caddy::install {
  assert_private()

  $bin_file = "${caddy::install_path}/caddy"

  if $caddy::version and $caddy::install_method != 'github' {
    fail('caddy::version can only be set when caddy::install_method is github')
  }

  case $caddy::install_method {
    'repo': {
      contain caddy::install::repo
    }
    'github': {
      unless $caddy::version {
        fail('caddy::version must be set when caddy::install_method is github')
      }
      contain caddy::install::github
    }
    'site': {
      contain caddy::install::site
    }
    default: {
      fail("Install method ${caddy::install_method} is not supported!")
    }
  }
}
