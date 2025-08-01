# frozen_string_literal: true

require 'spec_helper'

describe 'caddy' do
  on_supported_os.each do |os, os_facts|
    context "on #{os} with Facter #{os_facts[:facterversion]} and Puppet #{os_facts[:puppetversion]}" do
      let(:facts) do
        os_facts
      end

      case os_facts[:os]['family']
      when 'Debian'
        caddy_shell = '/usr/sbin/nologin'
        has_repo = true
      when 'RedHat'
        caddy_shell = '/sbin/nologin'
        has_repo = true
      else
        caddy_shell = '/sbin/nologin'
        has_repo = false
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('caddy') }
        it { is_expected.to contain_class('caddy::install').that_comes_before('Class[caddy::config]') }
        it { is_expected.to contain_class('caddy::config').that_notifies('Class[caddy::service]') }
        it { is_expected.to contain_class('caddy::service') }

        it do
          is_expected.to contain_group('caddy').with(
            'ensure' => 'present',
            'system' => 'true'
          )
        end

        it do
          is_expected.to contain_user('caddy').with(
            'ensure' => 'present',
            'shell' => caddy_shell,
            'gid' => 'caddy',
            'system' => 'true',
            'home' => '/var/lib/caddy'
          ).that_requires('Group[caddy]')
        end

        it do
          is_expected.to contain_file('/opt/caddy').with(
            'ensure' => 'directory',
            'owner' => 'caddy',
            'group' => 'caddy',
            'mode' => '0755'
          )
        end

        it do
          is_expected.to contain_file('/var/cache/caddy-latest').
            with_ensure('file').
            with_owner('root').
            with_group('root').
            with_mode('0755').
            with_source('https://caddyserver.com/api/download?os=linux&arch=amd64&plugins=http.git,http.filter,http.ipfilter&license=personal&telemetry=off').
            with_replace(false)
        end

        it do
          is_expected.to contain_file('/opt/caddy/caddy').
            with_ensure('file').
            with_owner('root').
            with_group('root').
            with_mode('0755').
            with_source('/var/cache/caddy-latest').
            that_requires('File[/opt/caddy]')
        end

        it do
          is_expected.to contain_file('/var/lib/caddy').with(
            'ensure' => 'directory',
            'owner' => 'caddy',
            'group' => 'caddy',
            'mode' => '0755'
          )
        end

        it do
          is_expected.to contain_file('/etc/ssl/caddy').with(
            'ensure' => 'directory',
            'owner' => 'caddy',
            'group' => 'caddy',
            'mode' => '0755'
          )
        end

        it do
          is_expected.to contain_file('/var/log/caddy').with(
            'ensure' => 'directory',
            'owner' => 'caddy',
            'group' => 'caddy',
            'mode' => '0755'
          )
        end

        it do
          is_expected.to contain_file('/etc/caddy').with(
            'ensure' => 'directory',
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0755'
          )
        end

        it do
          is_expected.to contain_file('/etc/caddy/Caddyfile').with(
            'ensure' => 'file',
            'owner' => 'caddy',
            'group' => 'caddy',
            'mode' => '0444',
            'source' => nil,
            'content' => %r{^import /etc/caddy/config/\*\.conf$}
          ).
            that_requires('File[/etc/caddy]')
        end

        it do
          is_expected.to contain_file('/etc/caddy/config').with(
            'ensure' => 'directory',
            'purge' => 'true',
            'recurse' => 'true',
            'owner' => 'caddy',
            'group' => 'caddy',
            'mode' => '0755'
          )
        end

        it do
          is_expected.to contain_systemd__unit_file('caddy.service').with(
            'content' => %r{User=caddy}
          ).that_notifies('Service[caddy]')
        end

        it do
          is_expected.to contain_service('caddy').with(
            'ensure' => 'running',
            'enable' => true
          )
        end
      end

      context 'with specific version' do
        let(:params) do
          {
            version: '2.0.0',
            install_method: 'github'
          }
        end

        it do
          is_expected.to contain_archive('/var/cache/caddy_2.0.0_linux_amd64.tar.gz').with(
            'ensure' => 'present',
            'extract' => 'true',
            'extract_path' => '/var/cache/caddy-2.0.0',
            'source' => 'https://github.com/caddyserver/caddy/releases/download/v2.0.0/caddy_2.0.0_linux_amd64.tar.gz',
            'user' => 'root',
            'group' => 'root'
          )
        end

        it do
          is_expected.to contain_file('/opt/caddy/caddy').
            with_ensure('file').
            with_owner('root').
            with_group('root').
            with_mode('0755').
            with_source('/var/cache/caddy-2.0.0/caddy').
            that_requires('File[/opt/caddy]')
        end
      end

      context 'with install_method => repo' do
        let(:params) { { install_method: 'repo' } }

        case os_facts[:os]['family']
        when 'Debian'
          context 'on Debian family' do
            it { is_expected.to contain_class('apt') }

            # it do
            #   is_expected.to contain_apt__source('caddy').
            #     with_location('https://dl.cloudsmith.io/public/caddy/stable/deb/debian').
            #     with_key(
            #       'name' => 'caddy-archive-keyring.asc',
            #       'source' => 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key'
            #     ).that_comes_before('Package[caddy]')
            # end

            it do
              is_expected.to contain_file('/etc/apt/keyrings/caddy-archive-keyring.asc').
                with_ensure('file').
                with_source('https://dl.cloudsmith.io/public/caddy/stable/gpg.key').
                with_checksum('sha256').
                with_checksum_value('5791c2fb6b6e82feb5a69834dd2131f4bcc30af0faec37783b2dc1c5c224a82a').
                that_comes_before('Apt::Source[caddy]')
            end

            it do
              is_expected.to contain_apt__source('caddy').
                with_location('https://dl.cloudsmith.io/public/caddy/stable/deb/debian').
                with_keyring('/etc/apt/keyrings/caddy-archive-keyring.asc').
                without_key.
                that_comes_before('Package[caddy]')
            end

            it { is_expected.to contain_package('caddy').with_ensure('installed') }

            context 'with manage_repo => false' do
              let(:params) { super().merge(manage_repo: false) }

              it { is_expected.not_to contain_apt__source('caddy') }
            end
          end
        when 'RedHat'
          context 'on RedHat family' do
            it { is_expected.to contain_class('yum') }

            it do
              is_expected.to contain_yum__copr('caddy').
                with_copr_repo('@caddy/caddy').
                with_ensure('enabled').
                that_comes_before('Package[caddy]')
            end

            it { is_expected.to contain_package('caddy').with_ensure('installed') }

            context 'with manage_repo => false' do
              let(:params) { super().merge(manage_repo: false) }

              it { is_expected.not_to contain_yum__copr('@caddy/caddy') }
            end
          end
        else
          it { is_expected.to raise_error(%r{has no support for 'repo' install method}) }
        end

        # There should be no unit file managed when install_method is 'repo'
        it { is_expected.not_to contain_systemd__unit_file('caddy.service') }

        context 'without repo_settings' do
          let(:params) { super().merge(repo_settings: {}) }

          it { is_expected.to raise_error(%r{'repo_settings' parameter should be set}) }
        end

        if has_repo
          context 'with package_name => test' do
            let(:params) { super().merge(package_name: 'test') }

            it { is_expected.to contain_package('test').with_ensure('installed') }
          end

          context 'with package_ensure => 2.3.4' do
            let(:params) { super().merge(package_ensure: '2.3.4') }

            it { is_expected.to contain_package('caddy').with_ensure('2.3.4') }
          end
        end
      end

      context 'with caddy_user => test_user' do
        let(:params) { { caddy_user: 'test_user' } }

        it { is_expected.to contain_user('test_user') }
      end

      context 'with caddy_group => test_group' do
        let(:params) { { caddy_user: 'test_group' } }

        it { is_expected.to contain_user('test_group') }
      end

      context 'with manage_user => false' do
        let(:params) { { manage_user: false } }

        it { is_expected.not_to contain_user('caddy') }
      end

      context 'with manage_group => false' do
        let(:params) { { manage_group: false } }

        it { is_expected.not_to contain_group('caddy') }
        it { is_expected.to contain_user('caddy').that_requires(nil) }
      end

      context 'with manage_systemd_unit => false' do
        let(:params) { { manage_systemd_unit: false } }

        it { is_expected.not_to contain_systemd__unit_file('caddy.service') }
      end

      context 'with manage_service => false' do
        let(:params) { { manage_service: false } }

        it { is_expected.to contain_systemd__unit_file('caddy.service').that_notifies(nil) }
        it { is_expected.not_to contain_service('caddy') }
      end

      context 'with service_name => custom' do
        let(:params) { { service_name: 'custom' } }

        it { is_expected.to contain_systemd__unit_file('custom.service') }
        it { is_expected.to contain_service('custom') }
      end

      context 'with service_ensure => stopped' do
        let(:params) { { service_ensure: 'stopped' } }

        it { is_expected.to contain_service('caddy').with_ensure('stopped') }
      end

      context 'with service_enable => false' do
        let(:params) { { service_enable: false } }

        it { is_expected.to contain_service('caddy').with_enable(false) }
      end

      context 'with manage_caddyfile => false' do
        let(:params) { { manage_caddyfile: false } }

        it { is_expected.not_to contain_file('/etc/caddy/Caddyfile') }
      end

      context 'with caddyfile_source set' do
        let(:params) { { caddyfile_source: 'http://example.com/Caddyfile' } }

        it { is_expected.to contain_file('/etc/caddy/Caddyfile').with_source('http://example.com/Caddyfile').with_content(nil) }
      end

      context 'with caddyfile_content set' do
        let(:params) { { caddyfile_content: "localhost\nfile_server\n" } }

        it { is_expected.to contain_file('/etc/caddy/Caddyfile').with_source(nil).with_content("localhost\nfile_server\n") }
      end

      context 'with both caddyfile_source and caddyfile_content set' do
        let(:params) do
          {
            caddyfile_source: 'http://example.com/Caddyfile',
            caddyfile_content: "localhost\nfile_server\n",
          }
        end

        it 'prefers source over content' do
          is_expected.to contain_file('/etc/caddy/Caddyfile').with_source('http://example.com/Caddyfile').with_content(nil)
        end
      end

      context 'with config_dir set' do
        let(:params) { { config_dir: '/etc/caddy/conf.d' } }

        it do
          is_expected.to contain_file('/etc/caddy/conf.d').
            with_ensure('directory').
            with_owner('caddy').
            with_group('caddy').
            with_mode('0755').
            with_purge(true).
            with_recurse(true)
        end

        it do
          is_expected.to contain_file('/etc/caddy/Caddyfile').
            with_content(%r{^import /etc/caddy/conf.d/\*\.conf$})
        end
      end

      context 'with purge_config_dir => false' do
        let(:params) { { purge_config_dir: false } }

        it do
          is_expected.to contain_file('/etc/caddy/config').
            with_ensure('directory').
            with_purge(false).
            with_recurse(nil)
        end
      end

      context 'with config_enable_dir set' do
        let(:params) { { config_enable_dir: '/etc/caddy/conf-enabled' } }

        it do
          is_expected.to contain_file('/etc/caddy/conf-enabled').
            with_ensure('directory').
            with_owner('caddy').
            with_group('caddy').
            with_mode('0755').
            with_purge(true).
            with_recurse(true)
        end

        it do
          is_expected.to contain_file('/etc/caddy/Caddyfile').
            with_content(%r{^import /etc/caddy/conf-enabled/\*\.conf$})
        end

        context 'with purge_config_enable_dir => false' do
          let(:params) { super().merge(purge_config_enable_dir: false) }

          it do
            is_expected.to contain_file('/etc/caddy/conf-enabled').
              with_ensure('directory').
              with_purge(false).
              with_recurse(nil)
          end
        end
      end

      context 'with both config_dir and config_enable_dir set' do
        let(:params) do
          {
            config_dir: '/etc/caddy/conf-available',
            config_enable_dir: '/etc/caddy/conf-enabled',
          }
        end

        it { is_expected.to contain_file('/etc/caddy/conf-available') }
        it { is_expected.to contain_file('/etc/caddy/conf-enabled') }

        it do
          is_expected.to contain_file('/etc/caddy/Caddyfile').
            with_content(%r{^import /etc/caddy/conf-enabled/\*\.conf$})
        end
      end

      context 'with vhost_dir set' do
        let(:params) { { vhost_dir: '/etc/caddy/vhost.d' } }

        it { is_expected.to contain_file('/etc/caddy/config').with_ensure('directory') }

        it do
          is_expected.to contain_file('/etc/caddy/vhost.d').
            with_ensure('directory').
            with_owner('caddy').
            with_group('caddy').
            with_mode('0755').
            with_purge(true).
            with_recurse(true)
        end

        it do
          is_expected.to contain_file('/etc/caddy/Caddyfile').
            with_content(%r{^import /etc/caddy/config/\*\.conf$}).
            with_content(%r{^import /etc/caddy/vhost.d/\*\.conf$})
        end

        context 'with purge_vhost_dir => false' do
          let(:params) { super().merge(purge_vhost_dir: false) }

          it do
            is_expected.to contain_file('/etc/caddy/vhost.d').
              with_ensure('directory').
              with_purge(false).
              with_recurse(nil)
          end
        end
      end

      context 'with vhost_enable_dir set' do
        let(:params) { { vhost_enable_dir: '/etc/caddy/sites-enabled' } }

        it do
          is_expected.to contain_file('/etc/caddy/sites-enabled').
            with_ensure('directory').
            with_owner('caddy').
            with_group('caddy').
            with_mode('0755').
            with_purge(true).
            with_recurse(true)
        end

        it do
          is_expected.to contain_file('/etc/caddy/Caddyfile').
            with_content(%r{^import /etc/caddy/config/\*\.conf$}).
            with_content(%r{^import /etc/caddy/sites-enabled/\*\.conf$})
        end

        context 'with purge_vhost_enable_dir => false' do
          let(:params) { super().merge(purge_vhost_enable_dir: false) }

          it do
            is_expected.to contain_file('/etc/caddy/sites-enabled').
              with_ensure('directory').
              with_purge(false).
              with_recurse(nil)
          end
        end
      end

      context 'with both vhost_dir and vhost_enable_dir set' do
        let(:params) do
          {
            vhost_dir: '/etc/caddy/sites-available',
            vhost_enable_dir: '/etc/caddy/sites-enabled',
          }
        end

        it { is_expected.to contain_file('/etc/caddy/sites-available') }
        it { is_expected.to contain_file('/etc/caddy/sites-enabled') }

        it do
          is_expected.to contain_file('/etc/caddy/Caddyfile').
            with_content(%r{^import /etc/caddy/config/\*\.conf$}).
            with_content(%r{^import /etc/caddy/sites-enabled/\*\.conf$})
        end
      end

      context 'with config_file_extension set' do
        let(:params) { { config_file_extension: '.caddyfile' } }

        it { is_expected.to contain_file('/etc/caddy/Caddyfile').with_content(%r{^import /etc/caddy/config/\*\.caddyfile$}) }
      end

      context 'with config_file_extension set to an empty string' do
        let(:params) { { config_file_extension: '' } }

        it { is_expected.to contain_file('/etc/caddy/Caddyfile').with_content(%r{^import /etc/caddy/config/\*$}) }
      end

      context 'with configs set' do
        let(:params) do
          {
            config_files: {
              example1: {
                source: 'puppet:///profiles/caddy/example1.conf',
              },
              example2: {
                ensure: 'disabled',
                content: "foo\nbar\n",
              },
              example3: {
                ensure: 'absent',
              }
            }
          }
        end

        it { is_expected.to contain_caddy__configfile('example1').with_ensure('enabled').with_source('puppet:///profiles/caddy/example1.conf') }
        it { is_expected.to contain_caddy__configfile('example2').with_ensure('disabled').with_content("foo\nbar\n") }
        it { is_expected.to contain_caddy__configfile('example3').with_ensure('absent') }
      end

      context 'with vhosts set' do
        let(:params) do
          {
            vhosts: {
              'h1.example.com': {
                source: 'http://example.com/test-example-com.conf',
              },
              'h2.example.com': {
                ensure: 'disabled',
                content: "localhost:1234{\n  file_server\n}\n",
              },
              'h3.example.com': {
                ensure: 'absent',
              }
            }
          }
        end

        it { is_expected.to contain_caddy__vhost('h1.example.com').with_ensure('enabled').with_source('http://example.com/test-example-com.conf') }
        it { is_expected.to contain_caddy__vhost('h2.example.com').with_ensure('disabled').with_content("localhost:1234{\n  file_server\n}\n") }
        it { is_expected.to contain_caddy__vhost('h3.example.com').with_ensure('absent') }
      end
    end
  end
end
