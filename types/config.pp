# @summary Caddy config file type
type Caddy::Config = Struct[{
    ensure => Optional[Enum['absent', 'present']],
    source => Optional[Stdlib::Filesource],
    content => Optional[String[1]],
}]
