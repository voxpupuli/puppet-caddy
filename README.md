# puppet-caddy

[![Build Status](https://travis-ci.org/voxpupuli/puppet-caddy.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-caddy)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-caddy/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-caddy)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/caddy.svg)](https://forge.puppetlabs.com/puppet/caddy)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/caddy.svg)](https://forge.puppetlabs.com/puppet/caddy)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/caddy.svg)](https://forge.puppetlabs.com/puppet/caddy)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/caddy.svg)](https://forge.puppetlabs.com/puppet/caddy)
[![License](https://img.shields.io/github/license/voxpupuli/puppet-caddy.svg)](https://github.com/voxpupuli/puppet-caddy/blob/master/LICENSE)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [TODO](#TODO)

## Overview

Puppet Caddy module installs and configures caddy - The HTTP/2 web server with automatic HTTPS.

## Module Description

Puppet Caddy module handles installing, configuring, and running Caddy server on Redhat based operating systems.

## Usage

### Install caddy with defaults:

```puppet
include caddy
```

### Install caddy with additiional features

```puppet
class {'caddy':
  caddy_features = "git,mailout,ipfilter",
}
```

### Add a Vhost with your configuration (```source``` or ```content```)

```puppet
caddy::vhost {'example1':
  source => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
}

caddy::vhost {'example2':
  source => 'puppet:///modules/caddy/etc/caddy/config/example2.conf',
}
```

## Parameters

### ```caddy_features```

Install Caddy with extra features

### ```install_path```

Caddy binary installation path - default /usr/local/bin

### ```caddy_user```

User to run caddy - default caddy

### ```caddy_group```

Group to run caddy - default caddy

### ```caddy_log_dir```

Caddy loggin directory - default /var/log/caddy

### ```caddy_tmp_dir```

Temp dir for caddy download

## Limitations

Tested on Centos 6.8 and Centos 7.3.

## TODO

* Improve management of Caddyfile (templates).
* Improve low port binding with systemd >= v229
* Improve defining resources with hiera

## License

MIT License
