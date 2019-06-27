# Class caddy::service
# ===========================
#
# Manage caddy service
#
class caddy::service inherits caddy {

  service { 'caddy':
    ensure => running,
    enable => true,
  }
}
