require 'spec_helper'

describe 'caddy::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with default values for Redhat family release 6' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_group('caddy').with(
            'ensure' => 'present',
            'system' => 'true'
          )
        end
        it do
          is_expected.to contain_user('caddy').with(
            'ensure'     => 'present',
            'shell'      => '/sbin/nologin',
            'gid'        => 'caddy',
            'system'     => 'true',
            'home'       => '/etc/ssl/caddy',
            'managehome' => 'true'
          )
        end
        it do
          is_expected.to contain_file('/etc/ssl/caddy/.caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755',
            'require' => 'User[caddy]'
          )
        end
        it do
          is_expected.to contain_file('/var/log/caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755',
            'require' => 'User[caddy]'
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
            'mode'    => '0755',
            'require' => 'User[caddy]'
          )
        end

        case facts[:os]['release']['major']
        when '7'
          it do
            is_expected.to contain_file('/etc/systemd/system/caddy.service').with(
              'ensure'  => 'file',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0744',
              'content' => %r{User=caddy},
              'notify'  => 'Exec[systemctl-daemon-reload]',
              'require' => 'Class[Caddy::Package]'
            )
          end
          it do
            is_expected.to contain_exec('systemctl-daemon-reload').with(
              'refreshonly' => 'true',
              'path'        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
              'command'     => 'systemctl daemon-reload'
            )
          end
        when '6'
          it do
            is_expected.to contain_file('/etc/init.d/caddy').with(
              'ensure'  => 'file',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0744',
              'content' => %r{DAEMONUSER=caddy},
              'require' => 'Class[Caddy::Package]'
            )
          end
        end
      end
    end
  end
end
