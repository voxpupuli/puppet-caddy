# @summary Caddy config file type
type Caddy::Config = Struct[{
  ensure => Optional[Enum['present','enabled','disabled','absent']],
  source => Optional[Stdlib::Filesource],
  content => Optional[String[1]],
}]
