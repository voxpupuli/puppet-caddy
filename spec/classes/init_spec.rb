# frozen_string_literal: true

require 'spec_helper'

describe 'caddy' do
  on_supported_os.each do |os, facts|
    context "on #{os} with Facter #{facts[:facterversion]} and Puppet #{facts[:puppetversion]}" do
      let(:facts) do
        facts
      end

      case facts[:os]['family']
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
            'source' => 'puppet:///modules/caddy/etc/caddy/Caddyfile'
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

        case facts[:os]['family']
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

            it { is_expected.to contain_package('caddy').with_ensure('2.0.0') }

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

            it { is_expected.to contain_package('caddy').with_ensure('2.0.0') }

            context 'with manage_repo => false' do
              let(:params) { super().merge(manage_repo: false) }

              it { is_expected.not_to contain_yum__copr('@caddy/caddy') }
            end
          end
        else
          it { is_expected.to raise_error(%r{has no support for 'repo' install method}) }
        end

        context 'without repo_settings' do
          let(:params) { super().merge(repo_settings: {}) }

          it { is_expected.to raise_error(%r{'repo_settings' parameter should be set}) }
        end

        if has_repo
          context 'with package_name => test' do
            let(:params) { super().merge(package_name: 'test') }

            it { is_expected.to contain_package('test').with_ensure('2.0.0') }
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
        it { is_expected.to contain_service('caddy').that_subscribes_to(nil) }
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
    end
  end
end
