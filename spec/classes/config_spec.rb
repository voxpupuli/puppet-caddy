require 'spec_helper'
describe 'caddy::config' do
  context 'with default values for Redhat family release 6' do
    let(:facts) do
      { osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemmajrelease: '6',
        architecture: 'x86_64'
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/caddy') }
    it { is_expected.to contain_file('/etc/caddy/Caddyfile') }
    it { is_expected.to contain_file('/etc/caddy/config') }
    it { is_expected.to contain_file('/var/log/caddy') }
    it { is_expected.to contain_user('caddy') }
    it { is_expected.to contain_group('caddy') }
    it { is_expected.to contain_file('/etc/init.d/caddy') }
  end
  context 'with default values for Redhat family release 7' do
    let(:facts) do
      { osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemmajrelease: '7',
        architecture: 'x86_64'
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/systemd/system/caddy.service') }
    it { is_expected.to contain_file('/etc/systemd/system/caddy.service').that_notifies(['Exec[systemctl-daemon-reload]']) }
    it do
      is_expected.to contain_exec('systemctl-daemon-reload').with(
        refreshonly: 'true',
        path: '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
        command: 'systemctl daemon-reload'
      )
    end
  end
  context 'with default values for Debian family, Ubuntu 18.04' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu',
        operatingsystemmajrelease: '18.04',
        architecture: 'x86_64'
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/lib/systemd/system/caddy.service') }
    it { is_expected.to contain_file('/lib/systemd/system/caddy.service').that_notifies(['Exec[systemctl-daemon-reload]']) }
    it { is_expected.to contain_file('/etc/caddy/Caddyfile') }
    it { is_expected.to contain_file('/etc/caddy/config') }
    it { is_expected.to contain_user('www-data') }
    it { is_expected.to contain_group('www-data') }

    it do
      is_expected.to contain_exec('systemctl-daemon-reload').with(
        refreshonly: 'true',
        path: '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
        command: 'systemctl daemon-reload'
      )
    end
  end
end
