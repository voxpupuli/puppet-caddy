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
          is_expected.to contain_file('/opt/caddy/caddy').with(
              'ensure'  => 'file',
              'owner'   => 'root',
              'group'   => 'root',
              'source'  => 'https://caddyserver.com/api/download?os=linux&arch=amd64&plugins=http.git,http.filter,http.ipfilter&license=personal&telemetry=off',
              'notify'  => 'File_capability[/opt/caddy/caddy]',
              'require' => 'File[/opt/caddy]'
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
            'mode'    => '0444',
            'source'  => 'puppet:///modules/caddy/etc/caddy/Caddyfile',
            'require' => 'File[/etc/caddy]'
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

      context 'using github install method' do
        context 'version 1.x' do
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

        context 'version 2.x' do
          let(:params) do
            {
                version: '2.2.0',
                install_method: 'github'
            }
          end

          it do
            is_expected.to contain_archive('/tmp/caddy_2.2.0_linux_amd64.tar.gz').with(
                'ensure'       => 'present',
                'extract'      => 'true',
                'extract_path' => '/opt/caddy',
                'source'       => 'https://github.com/caddyserver/caddy/releases/download/v2.2.0/caddy_2.2.0_linux_amd64.tar.gz',
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
end
