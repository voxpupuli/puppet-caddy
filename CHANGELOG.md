# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v2.0.0](https://github.com/voxpupuli/puppet-caddy/tree/v2.0.0) (2020-04-29)

[Full Changelog](https://github.com/voxpupuli/puppet-caddy/compare/v1.0.0...v2.0.0)

**Breaking changes:**

- Change the default values [\#64](https://github.com/voxpupuli/puppet-caddy/pull/64) ([dhoppe](https://github.com/dhoppe))
- Add support for Debian 8/9/10, Ubuntu 16.04/18.04 [\#49](https://github.com/voxpupuli/puppet-caddy/pull/49) ([dhoppe](https://github.com/dhoppe))

**Implemented enhancements:**

- Add support for stm/file\_capability [\#46](https://github.com/voxpupuli/puppet-caddy/issues/46)
- Update README.md [\#44](https://github.com/voxpupuli/puppet-caddy/issues/44)
- Add support for assert\_private\(\) function [\#39](https://github.com/voxpupuli/puppet-caddy/issues/39)
- Add support for ordering / notify arrows [\#38](https://github.com/voxpupuli/puppet-caddy/issues/38)
- Add support for puppetlabs/puppet-strings [\#33](https://github.com/voxpupuli/puppet-caddy/issues/33)
- Add support for latest available releases [\#32](https://github.com/voxpupuli/puppet-caddy/issues/32)
- Add support for Hiera [\#31](https://github.com/voxpupuli/puppet-caddy/issues/31)
- Add support for puppet/archive [\#30](https://github.com/voxpupuli/puppet-caddy/issues/30)
- Add support for camptocamp/systemd [\#29](https://github.com/voxpupuli/puppet-caddy/issues/29)
- Migrate from .erb to .epp templates [\#61](https://github.com/voxpupuli/puppet-caddy/pull/61) ([dhoppe](https://github.com/dhoppe))
- Add support for a specific version [\#60](https://github.com/voxpupuli/puppet-caddy/pull/60) ([dhoppe](https://github.com/dhoppe))
- Support Redhat 8 [\#35](https://github.com/voxpupuli/puppet-caddy/pull/35) ([qs5779](https://github.com/qs5779))

**Closed issues:**

- Roadmap for Caddy 1 / Caddy 2 [\#63](https://github.com/voxpupuli/puppet-caddy/issues/63)
- Support a specific version [\#59](https://github.com/voxpupuli/puppet-caddy/issues/59)
- Migrate from .erb to .epp templates [\#55](https://github.com/voxpupuli/puppet-caddy/issues/55)
- Change the default values [\#54](https://github.com/voxpupuli/puppet-caddy/issues/54)
- Reduce number of duplicate parameters [\#40](https://github.com/voxpupuli/puppet-caddy/issues/40)
- Improve RSpec tests [\#37](https://github.com/voxpupuli/puppet-caddy/issues/37)

**Merged pull requests:**

- Fix typo [\#52](https://github.com/voxpupuli/puppet-caddy/pull/52) ([dhoppe](https://github.com/dhoppe))
- Fix README.md [\#51](https://github.com/voxpupuli/puppet-caddy/pull/51) ([dhoppe](https://github.com/dhoppe))
- Add support for stm/file\_capability [\#47](https://github.com/voxpupuli/puppet-caddy/pull/47) ([dhoppe](https://github.com/dhoppe))
- Add support for puppet/archive [\#45](https://github.com/voxpupuli/puppet-caddy/pull/45) ([dhoppe](https://github.com/dhoppe))
- Refactor Puppet manifests [\#43](https://github.com/voxpupuli/puppet-caddy/pull/43) ([dhoppe](https://github.com/dhoppe))
- Move resources to related classes [\#42](https://github.com/voxpupuli/puppet-caddy/pull/42) ([dhoppe](https://github.com/dhoppe))
- Reduce number of duplicate parameters [\#41](https://github.com/voxpupuli/puppet-caddy/pull/41) ([dhoppe](https://github.com/dhoppe))
- Improve the RSpec tests [\#36](https://github.com/voxpupuli/puppet-caddy/pull/36) ([dhoppe](https://github.com/dhoppe))

## [v1.0.0](https://github.com/voxpupuli/puppet-caddy/tree/v1.0.0) (2020-04-24)

[Full Changelog](https://github.com/voxpupuli/puppet-caddy/compare/v0.2.0...v1.0.0)

**Breaking changes:**

- modulesync 2.7.0 and drop puppet 4 [\#16](https://github.com/voxpupuli/puppet-caddy/pull/16) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Migrate caddy module to Vox Pupuli [\#2](https://github.com/voxpupuli/puppet-caddy/issues/2)

**Merged pull requests:**

- Use voxpupuli-acceptance [\#25](https://github.com/voxpupuli/puppet-caddy/pull/25) ([ekohl](https://github.com/ekohl))
- update repo links to https [\#23](https://github.com/voxpupuli/puppet-caddy/pull/23) ([bastelfreak](https://github.com/bastelfreak))
- Allow puppetlabs/stdlib 6.x [\#22](https://github.com/voxpupuli/puppet-caddy/pull/22) ([dhoppe](https://github.com/dhoppe))
- modulesync 2.6.0 [\#15](https://github.com/voxpupuli/puppet-caddy/pull/15) ([dhoppe](https://github.com/dhoppe))
- Fix typo at documentation [\#14](https://github.com/voxpupuli/puppet-caddy/pull/14) ([dhoppe](https://github.com/dhoppe))

## [v0.2.0](https://github.com/voxpupuli/puppet-caddy/tree/v0.2.0) (2018-12-28)

[Full Changelog](https://github.com/voxpupuli/puppet-caddy/compare/v0.1.2...v0.2.0)

**Breaking changes:**

- Fix the path of binary: /usr/bin -\> /usr/local/bin [\#5](https://github.com/voxpupuli/puppet-caddy/pull/5) ([dhoppe](https://github.com/dhoppe))

**Implemented enhancements:**

- alternative HTTP/S ports, fix download commercial license, alternativ… [\#12](https://github.com/voxpupuli/puppet-caddy/pull/12) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- modulesync 2.1.0 and allow puppet 6.x [\#7](https://github.com/voxpupuli/puppet-caddy/pull/7) ([bastelfreak](https://github.com/bastelfreak))
- Fix typo in README.md [\#6](https://github.com/voxpupuli/puppet-caddy/pull/6) ([ekohl](https://github.com/ekohl))
- Fix Markdown syntax [\#4](https://github.com/voxpupuli/puppet-caddy/pull/4) ([dhoppe](https://github.com/dhoppe))

## [v0.1.2](https://github.com/voxpupuli/puppet-caddy/tree/v0.1.2) (2017-01-24)

[Full Changelog](https://github.com/voxpupuli/puppet-caddy/compare/v0.1.1...v0.1.2)

## [v0.1.1](https://github.com/voxpupuli/puppet-caddy/tree/v0.1.1) (2017-01-12)

[Full Changelog](https://github.com/voxpupuli/puppet-caddy/compare/0.1.0...v0.1.1)

## [0.1.0](https://github.com/voxpupuli/puppet-caddy/tree/0.1.0) (2017-01-12)

[Full Changelog](https://github.com/voxpupuli/puppet-caddy/compare/3e19ad2f589c42f58dbafbb10d50b6d88882d857...0.1.0)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
