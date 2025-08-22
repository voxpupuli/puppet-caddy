# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.0.0](https://github.com/voxpupuli/puppet-caddy/tree/v3.0.0) (2025-08-22)

[Full Changelog](https://github.com/voxpupuli/puppet-caddy/compare/v2.0.0...v3.0.0)

**Breaking changes:**

- Drop puppet, update openvox minimum version to 8.19 [\#143](https://github.com/voxpupuli/puppet-caddy/pull/143) ([TheMeier](https://github.com/TheMeier))
- Drop CentOS 7/8, Debian 10, RedHat 7, Ubuntu 18.04 [\#112](https://github.com/voxpupuli/puppet-caddy/pull/112) ([jay7x](https://github.com/jay7x))
- Require a version when installing from GitHub [\#97](https://github.com/voxpupuli/puppet-caddy/pull/97) ([smortex](https://github.com/smortex))
- Do not cache files in /tmp & remove stm/file\_capability dependency [\#96](https://github.com/voxpupuli/puppet-caddy/pull/96) ([smortex](https://github.com/smortex))
- Rework capabilities management [\#93](https://github.com/voxpupuli/puppet-caddy/pull/93) ([smortex](https://github.com/smortex))
- Drop Debian 8, 9 and Ubuntu 16.04 \(EOL\) [\#87](https://github.com/voxpupuli/puppet-caddy/pull/87) ([smortex](https://github.com/smortex))
- Use Caddy 2.x syntax [\#86](https://github.com/voxpupuli/puppet-caddy/pull/86) ([smortex](https://github.com/smortex))
- Drop Puppet 6 support [\#81](https://github.com/voxpupuli/puppet-caddy/pull/81) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- puppet/archive Allow 8.x [\#142](https://github.com/voxpupuli/puppet-caddy/pull/142) ([TheMeier](https://github.com/TheMeier))
- Use 'site' install\_method instead of `undef` to install Caddy from the official site [\#134](https://github.com/voxpupuli/puppet-caddy/pull/134) ([jay7x](https://github.com/jay7x))
- metadata.json: Add OpenVox [\#124](https://github.com/voxpupuli/puppet-caddy/pull/124) ([jstraw](https://github.com/jstraw))
- Allow to change default config files extension [\#120](https://github.com/voxpupuli/puppet-caddy/pull/120) ([jay7x](https://github.com/jay7x))
- Implement support for conf-{available,enabled} as well [\#119](https://github.com/voxpupuli/puppet-caddy/pull/119) ([jay7x](https://github.com/jay7x))
- Implement vhost\_dir and vhost\_enable\_dir support [\#118](https://github.com/voxpupuli/puppet-caddy/pull/118) ([jay7x](https://github.com/jay7x))
- Improve caddy config files management [\#116](https://github.com/voxpupuli/puppet-caddy/pull/116) ([jay7x](https://github.com/jay7x))
- Allow to install caddy from repos [\#114](https://github.com/voxpupuli/puppet-caddy/pull/114) ([jay7x](https://github.com/jay7x))
- Allow to manage caddy user/group/systemd unit/service parameters separately [\#113](https://github.com/voxpupuli/puppet-caddy/pull/113) ([jay7x](https://github.com/jay7x))
- Add AlmaLinux 8/9, CentOS 9, Debian 11/12, Fedora 40, OL 8/9, RHEL 9, Rocky 8/9, Ubuntu 20.04/22.04/24.04 [\#111](https://github.com/voxpupuli/puppet-caddy/pull/111) ([jay7x](https://github.com/jay7x))
- puppet/systemd: Allow 6.x [\#102](https://github.com/voxpupuli/puppet-caddy/pull/102) ([zilchms](https://github.com/zilchms))
- Allow stm/file\_capability 6.x [\#89](https://github.com/voxpupuli/puppet-caddy/pull/89) ([smortex](https://github.com/smortex))
- Allow puppet/systemd 5.x [\#88](https://github.com/voxpupuli/puppet-caddy/pull/88) ([smortex](https://github.com/smortex))
- Add Puppet 8 support [\#83](https://github.com/voxpupuli/puppet-caddy/pull/83) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Allow 9.x [\#82](https://github.com/voxpupuli/puppet-caddy/pull/82) ([bastelfreak](https://github.com/bastelfreak))
- puppet/archive: allow 5.x [\#77](https://github.com/voxpupuli/puppet-caddy/pull/77) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- RHEL8 repos has version 2.9.1 as latest available [\#130](https://github.com/voxpupuli/puppet-caddy/issues/130)
- Do not manage systemd unit when install\_method is "repo" [\#129](https://github.com/voxpupuli/puppet-caddy/issues/129)
- Do not manage systemd unit when installing caddy from a repo [\#131](https://github.com/voxpupuli/puppet-caddy/pull/131) ([jay7x](https://github.com/jay7x))
- Fix installation of a specific caddy version [\#95](https://github.com/voxpupuli/puppet-caddy/pull/95) ([smortex](https://github.com/smortex))
- Actually fix github [\#84](https://github.com/voxpupuli/puppet-caddy/pull/84) ([AstraLuma](https://github.com/AstraLuma))

**Closed issues:**

- The `version` parameter is deceptive [\#94](https://github.com/voxpupuli/puppet-caddy/issues/94)
- `caddy` binary not updated after `version` / `install_method` is changed [\#92](https://github.com/voxpupuli/puppet-caddy/issues/92)
- Acceptance tests do not pass in Vagrant [\#91](https://github.com/voxpupuli/puppet-caddy/issues/91)
- Caddy download URL moved [\#85](https://github.com/voxpupuli/puppet-caddy/issues/85)
- Installation from Github source fails [\#75](https://github.com/voxpupuli/puppet-caddy/issues/75)
- End support for Caddy 1 [\#66](https://github.com/voxpupuli/puppet-caddy/issues/66)
- Create a final release for Caddy 1 [\#65](https://github.com/voxpupuli/puppet-caddy/issues/65)
- Add support for .deb / .rpm repositories [\#62](https://github.com/voxpupuli/puppet-caddy/issues/62)
- Make Caddyfile more configurable [\#58](https://github.com/voxpupuli/puppet-caddy/issues/58)
- Check for Systemd version [\#57](https://github.com/voxpupuli/puppet-caddy/issues/57)
- Support for caddy v2 [\#34](https://github.com/voxpupuli/puppet-caddy/issues/34)

**Merged pull requests:**

- chore\(config\): migrate renovate config [\#141](https://github.com/voxpupuli/puppet-caddy/pull/141) ([renovate[bot]](https://github.com/apps/renovate))
- puppet/systemd: allow 8.x [\#117](https://github.com/voxpupuli/puppet-caddy/pull/117) ([jay7x](https://github.com/jay7x))
- Bump puppet-archive version upper boundary and fix github download idempotency [\#115](https://github.com/voxpupuli/puppet-caddy/pull/115) ([jay7x](https://github.com/jay7x))
- update puppet-systemd upper bound to 8.0.0 [\#106](https://github.com/voxpupuli/puppet-caddy/pull/106) ([TheMeier](https://github.com/TheMeier))
- Make sure acceptance tests are idempotent [\#90](https://github.com/voxpupuli/puppet-caddy/pull/90) ([smortex](https://github.com/smortex))
- switch from camptocamp/systemd to voxpupuli/systemd [\#78](https://github.com/voxpupuli/puppet-caddy/pull/78) ([bastelfreak](https://github.com/bastelfreak))
- Fix typo on installing package from github [\#76](https://github.com/voxpupuli/puppet-caddy/pull/76) ([djordjeparovic](https://github.com/djordjeparovic))

## [v2.0.0](https://github.com/voxpupuli/puppet-caddy/tree/v2.0.0) (2020-05-14)

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

- Support a specific version [\#59](https://github.com/voxpupuli/puppet-caddy/issues/59)
- Migrate from .erb to .epp templates [\#55](https://github.com/voxpupuli/puppet-caddy/issues/55)
- Change the default values [\#54](https://github.com/voxpupuli/puppet-caddy/issues/54)
- Reduce number of duplicate parameters [\#40](https://github.com/voxpupuli/puppet-caddy/issues/40)
- Improve RSpec tests [\#37](https://github.com/voxpupuli/puppet-caddy/issues/37)
- Create a final release for Caddy 1 [\#65](https://github.com/voxpupuli/puppet-caddy/issues/65)

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
