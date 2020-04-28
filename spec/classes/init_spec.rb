require 'spec_helper'

describe 'caddy' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      case facts[:os]['family']
      when 'Debian'
        caddy_shell   = '/usr/sbin/nologin'
      when 'RedHat'
        caddy_shell   = '/sbin/nologin'
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('caddy') }
        it do
          is_expected.to contain_group('caddy').with(
            'ensure' => 'present',
            'system' => 'true'
          )
        end
        it do
          is_expected.to contain_user('caddy').with(
            'ensure'     => 'present',
            'shell'      => caddy_shell,
            'gid'        => 'caddy',
            'system'     => 'true',
            'home'       => '/var/lib/caddy'
          )
        end

        it do
          is_expected.to contain_file('/opt/caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755'
          )
        end
        it do
          is_expected.to contain_archive('/tmp/caddy_linux_amd64_custom.tar.gz').with(
            'ensure'       => 'present',
            'extract'      => 'true',
            'extract_path' => '/opt/caddy',
            'source'       => 'https://caddyserver.com/download/linux/amd64?plugins=http.git,http.filter,http.ipfilter&license=personal&telemetry=off',
            'user'         => 'root',
            'group'        => 'root',
            'creates'      => '/opt/caddy/caddy',
            'cleanup'      => 'true',
            'notify'       => 'File_capability[/opt/caddy/caddy]',
            'require'      => 'File[/opt/caddy]'
          )
        end
        it do
          is_expected.to contain_file_capability('/opt/caddy/caddy').with(
            'ensure'     => 'present',
            'capability' => 'cap_net_bind_service=ep',
            'require'    => 'Archive[/tmp/caddy_linux_amd64_custom.tar.gz]'
          )
        end

        it do
          is_expected.to contain_file('/var/lib/caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755'
          )
        end
        it do
          is_expected.to contain_file('/etc/ssl/caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755'
          )
        end
        it do
          is_expected.to contain_file('/var/log/caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755'
          )
        end
        it do
          is_expected.to contain_file('/etc/caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0755'
          )
        end
        it do
          is_expected.to contain_file('/etc/caddy/Caddyfile').with(
            'ensure'  => 'file',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0444'
          )
        end
        it do
          is_expected.to contain_file('/etc/caddy/config').with(
            'ensure'  => 'directory',
            'purge'   => 'true',
            'recurse' => 'true',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755'
          )
        end

        case facts['service_provider']
        when 'systemd'
          it do
            is_expected.to contain_systemd__unit_file('caddy.service').with(
              'content' => %r{User=caddy}
            )
          end
        when 'redhat'
          it do
            is_expected.to contain_file('/etc/init.d/caddy').with(
              'ensure'  => 'file',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0755',
              'content' => %r{DAEMONUSER=caddy}
            )
          end
        end
        it do
          is_expected.to contain_service('caddy').with(
            'ensure' => 'running',
            'enable' => 'true'
          )
        end
      end

      context 'with specific version' do
        let(:params) do
          {
            version: '1.0.3',
            install_method: 'github'
          }
        end

        it do
          is_expected.to contain_archive('/tmp/caddy_v1.0.3_linux_amd64.tar.gz').with(
            'ensure'       => 'present',
            'extract'      => 'true',
            'extract_path' => '/opt/caddy',
            'source'       => 'https://github.com/caddyserver/caddy/releases/download/v1.0.3/caddy_v1.0.3_linux_amd64.tar.gz',
            'user'         => 'root',
            'group'        => 'root',
            'creates'      => '/opt/caddy/caddy',
            'cleanup'      => 'true',
            'notify'       => 'File_capability[/opt/caddy/caddy]'
          )
        end
      end
    end
  end
end
