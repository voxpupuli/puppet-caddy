# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

_Public Classes_

* [`caddy`](#caddy): Main class, includes all other classes.

_Private Classes_

* `caddy::config`: This class handles the Caddy config.
* `caddy::install`: This class handles the Caddy archive.
* `caddy::service`: This class handles the Caddy service.

**Defined types**

* [`caddy::vhost`](#caddyvhost): This defined type handles the Caddy virtual hosts.

## Classes

### caddy

Main class, includes all other classes.

#### Examples

##### Basic usage

```puppet
include caddy
```

##### Install Caddy with additional features

```puppet
class { 'caddy':
  caddy_features => 'http.git, http.filter, http.ipfilter',
}
```

#### Parameters

The following parameters are available in the `caddy` class.

##### `install_path`

Data type: `Stdlib::Absolutepath`

Directory where the Caddy binary is stored.

Default value: '/usr/local/bin'

##### `caddy_user`

Data type: `String`

The user used by the Caddy process.

Default value: 'caddy'

##### `caddy_group`

Data type: `String`

The group used by the Caddy process.

Default value: 'caddy'

##### `caddy_log_dir`

Data type: `Stdlib::Absolutepath`

Directory where the log files are stored.

Default value: '/var/log/caddy'

##### `caddy_tmp_dir`

Data type: `Stdlib::Absolutepath`

Directory where the Caddy archive is stored.

Default value: '/tmp'

##### `caddy_home`

Data type: `Stdlib::Absolutepath`

Directory where the Caddy data is stored.

Default value: '/etc/ssl/caddy'

##### `caddy_ssl_dir`

Data type: `Stdlib::Absolutepath`

Directory where Let's Encrypt certificates are stored.

Default value: "${caddy_home}/.caddy"

##### `caddy_license`

Data type: `Enum['personal', 'commercial']`

Whether a personal or commercial license is used.

Default value: 'personal'

##### `caddy_telemetry`

Data type: `Enum['on','off']`

Whether telemetry data should be collected.

Default value: 'off'

##### `caddy_features`

Data type: `String`

A list of features the Caddy binary should support.

Default value: 'http.filter,http.git,http.ipfilter'

##### `caddy_http_port`

Data type: `Stdlib::Port`

Which port for HTTP is used.

Default value: 80

##### `caddy_https_port`

Data type: `Stdlib::Port`

Which port for HTTPS is used.

Default value: 443

##### `caddy_private_device`

Whether physical devices are turned off.

##### `caddy_limit_processes`

Data type: `Integer`

The maximum number of Caddy processes.

Default value: 64

##### `caddy_architecture`

Data type: `String`

A temporary variable, required for the download URL.

Default value: $facts['os']['architecture']

##### `caddy_account_id`

Data type: `Optional[String[1]]`

The account ID, required for the commercial license.

Default value: `undef`

##### `caddy_api_key`

Data type: `Optional[String[1]]`

The API key, required for the commercial license.

Default value: `undef`

##### `caddy_private_devices`

Data type: `Boolean`



Default value: `true`

## Defined types

### caddy::vhost

This defined type handles the Caddy virtual hosts.

#### Examples

##### Configure virtual host, based on source

```puppet
caddy::vhost { 'example1':
  source => 'puppet:///modules/caddy/etc/caddy/config/example1.conf'
}
```

##### Configure virtual host, based on content

```puppet
caddy::vhost { 'example2:
  content => 'localhost:2015',
}
```

#### Parameters

The following parameters are available in the `caddy::vhost` defined type.

##### `source`

Data type: `Any`



Default value: `undef`

##### `content`

Data type: `Any`



Default value: `undef`
