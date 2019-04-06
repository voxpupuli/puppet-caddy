# Class caddy::service
# ===========================
#
# Manage caddy service
#
class caddy::service {
  service{'caddy':
    ensure => running,
    enable => true,
  }
}
