# Puppet Caddy Module
#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [TODO](#TODO)

## Overview

Puppet Caddy module installs and configures caddy - The HTTP/2 web server with automatic HTTPS.

## Module Description

Puppet Caddy module handles installing, configuring, and running Caddy server on Redhat based oparting systems.

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

##Paramseters

###```caddy_features```

Install Caddy with extra features

###```install_path```

Caddy binary installation path - default /usr/bin

###```caddy_user```

User to run caddy - default caddy

###```caddy_group```

Group to run caddy - default caddy

###```caddy_log_dir```

Caddy loggin directory - default /var/log/caddy

###```caddy_tmp_dir```

Temp dir for caddy download

## Limitations

Tested on Centos 6.8 and Centos 7.3.

## TODO

* Improve management of Caddyfile (templates).

## License

MIT License
