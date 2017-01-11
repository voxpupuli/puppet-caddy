# Class: caddy
# ===========================
#
# Examples
# --------
#
# ```puppet
# include caddy
# ```
#
# Install caddy with additiional features
#
# ```puppet
# class {'caddy':
#   caddy_features = "git,mailout,ipfilter",
# }
# ```
#
# Authors
# -------
#
# Lukasz Rohde <kujon447@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Lukasz Rohde.
#
class caddy (

  $install_path  = $caddy::params::install_path,
  $caddy_user    = $caddy::params::caddy_user,
  $caddy_log_dir = $caddy::params::caddy_log_dir,

  $caddy_features = 'git,mailout,ipfilter',

  )inherits caddy::params{

  include ::caddy::package
  include ::caddy::config
  include ::caddy::service
}
