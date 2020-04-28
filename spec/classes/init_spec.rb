require 'spec_helper'

describe 'caddy' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      case facts[:os]['family']
      when 'Debian'
        caddy_user    = 'www-data'
        caddy_group   = 'www-data'
        caddy_shell   = '/usr/sbin/nologin'
        caddy_home    = '/opt/caddy'
        caddy_ssl_dir = '/opt/caddy/.caddy'
      when 'RedHat'
        caddy_user    = 'caddy'
        caddy_group   = 'caddy'
        caddy_shell   = '/sbin/nologin'
        caddy_home    = '/etc/ssl/caddy'
        caddy_ssl_dir = '/etc/ssl/caddy/.caddy'
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('caddy') }
        it { is_expected.to contain_class('caddy::install').that_comes_before('Class[caddy::config]') }
        it { is_expected.to contain_class('caddy::config').that_notifies('Class[caddy::service]') }
        it { is_expected.to contain_class('caddy::service') }
        it do
          is_expected.to contain_group(caddy_group).with(
            'ensure' => 'present',
            'system' => 'true'
          )
        end
        it do
          is_expected.to contain_user(caddy_user).with(
            'ensure'     => 'present',
            'shell'      => caddy_shell,
            'gid'        => caddy_group,
            'system'     => 'true',
            'home'       => caddy_home
          )
        end

        it do
          is_expected.to contain_archive('/tmp/caddy_linux_amd64_custom.tar.gz').with(
            'ensure'       => 'present',
            'extract'      => 'true',
            'extract_path' => '/usr/local/bin',
            'source'       => 'https://caddyserver.com/download/linux/amd64?plugins=http.filter,http.git,http.ipfilter&license=personal&telemetry=off',
            'user'         => 'root',
            'group'        => 'root',
            'creates'      => '/usr/local/bin/caddy',
            'cleanup'      => 'true',
            'notify'       => 'File_capability[/usr/local/bin/caddy]'
          )
        end
        it do
          is_expected.to contain_file_capability('/usr/local/bin/caddy').with(
            'ensure'     => 'present',
            'capability' => 'cap_net_bind_service=ep',
            'require'    => 'Archive[/tmp/caddy_linux_amd64_custom.tar.gz]'
          )
        end

        it do
          is_expected.to contain_file(caddy_home).with(
            'ensure'  => 'directory',
            'owner'   => caddy_user,
            'group'   => caddy_group,
            'mode'    => '0755'
          )
        end
        it do
          is_expected.to contain_file(caddy_ssl_dir).with(
            'ensure'  => 'directory',
            'owner'   => caddy_user,
            'group'   => caddy_group,
            'mode'    => '0755'
          )
        end
        it do
          is_expected.to contain_file('/var/log/caddy').with(
            'ensure'  => 'directory',
            'owner'   => caddy_user,
            'group'   => caddy_group,
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
            'owner'   => caddy_user,
            'group'   => caddy_group,
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
            'owner'   => caddy_user,
            'group'   => caddy_group,
            'mode'    => '0755'
          )
        end

        case facts['service_provider']
        when 'systemd'
          it do
            is_expected.to contain_systemd__unit_file('caddy.service').with(
              'content' => %r{User=#{caddy_user}}
            )
          end
        when 'redhat'
          it do
            is_expected.to contain_file('/etc/init.d/caddy').with(
              'ensure'  => 'file',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0755',
              'content' => %r{DAEMONUSER=#{caddy_user}}
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
    end
  end
end
