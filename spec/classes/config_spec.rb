require 'spec_helper'

describe 'caddy::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with default values for Redhat family release 6' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_group('caddy') }
        it { is_expected.to contain_user('caddy') }
        it { is_expected.to contain_file('/etc/ssl/caddy/.caddy') }
        it { is_expected.to contain_file('/var/log/caddy') }
        it { is_expected.to contain_file('/etc/caddy') }
        it { is_expected.to contain_file('/etc/caddy/Caddyfile') }
        it { is_expected.to contain_file('/etc/caddy/config') }

        case facts[:os]['release']['major']
        when '7'
          it { is_expected.to contain_file('/etc/systemd/system/caddy.service') }
          it { is_expected.to contain_file('/etc/systemd/system/caddy.service').that_notifies(['Exec[systemctl-daemon-reload]']) }
          it do
            is_expected.to contain_exec('systemctl-daemon-reload').with(
              refreshonly: 'true',
              path: '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
              command: 'systemctl daemon-reload'
            )
          end
        when '6'
          it { is_expected.to contain_file('/etc/init.d/caddy') }
        end
      end
    end
  end
end
