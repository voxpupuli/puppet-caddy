# @summary Caddy virtual host type
type Caddy::VirtualHost = Struct[{
    ensure => Optional[Enum['absent', 'present']],
    source => Optional[Stdlib::Filesource],
    content => Optional[String[1]],
}]
