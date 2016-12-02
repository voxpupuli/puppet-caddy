require 'spec_helper'
describe 'caddy::config' do
  context 'with default values for Redhat family release 6' do
    let(:pre_condition) { 'class { "caddy::package": install_path => "/usr/bin", caddy_features => "git"}' }
    let(:facts) do
      { os: { family: 'RedHat', release: { major: '6' } } }
    end
    let(:params) do
      {
        install_path: '/usr/bin',
        caddy_user: 'caddy',
        caddy_log_dir: '/var/log/caddy'
      }
    end
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/init.d/caddy') }
  end
  context 'with default values for Redhat family release 7' do
    let(:pre_condition) { 'class { "caddy::package": install_path => "/usr/bin", caddy_features => "git"}' }
    let(:facts) do
      { os: { family: 'RedHat', release: { major: '7' } } }
    end
    let(:params) do
      {
        install_path: '/usr/bin',
        caddy_user: 'caddy',
        caddy_log_dir: '/var/log/caddy'
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
end
