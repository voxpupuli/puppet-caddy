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
#   caddy_features = "http.filter,http.git,http.ipfilter",
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

  $install_path      = $caddy::params::install_path,
  $caddy_user        = $caddy::params::caddy_user,
  $caddy_group       = $caddy::params::caddy_group,
  $caddy_log_dir     = $caddy::params::caddy_log_dir,
  $caddy_tmp_dir     = $caddy::params::caddy_tmp_dir,
  $caddy_features    = 'http.filter,http.git,http.ipfilter'

  )inherits caddy::params{

  include ::caddy::package
  include ::caddy::config
  include ::caddy::service
}
