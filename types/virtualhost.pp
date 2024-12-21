# @summary Caddy virtual host type
type Caddy::VirtualHost = Struct[{
    ensure => Optional[Enum['present','enabled','disabled','absent']],
    source => Optional[Stdlib::Filesource],
    content => Optional[String[1]],
}]
