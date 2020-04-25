require 'spec_helper'

describe 'caddy::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_service('caddy').with(
            'ensure' => 'running',
            'enable' => 'true'
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
