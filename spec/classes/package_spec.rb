require 'spec_helper'
describe 'caddy::package' do
  context 'with default values for all parameters' do
    let(:facts) do
      { osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemmajrelease: '6' }
    end
    let(:params) do
      {
        install_path: '/usr/bin',
        caddy_features: 'git'
      }
    end
    it { is_expected.to compile.with_all_deps }
    it do
      is_expected.to contain_file('caddy_installer_script').with(
        'ensure'  => 'file',
        'path'    => '/tmp/caddy_installer_script.sh',
        'mode'    => '0755',
        'owner'   => 'root',
        'group'   => 'root'
      )
    end
    it do
      is_expected.to contain_exec('install caddy').with(
        'command' => 'bash /tmp/caddy_installer_script.sh git',
        'creates' => '/usr/bin/caddy',
        'require' => 'File[caddy_installer_script]'
      )
    end
    it do
      is_expected.to contain_file('/usr/bin/caddy').with(
        'mode'    => '0755',
        'owner'   => 'root',
        'group'   => 'root',
        'require' => 'Exec[install caddy]'
      )
    end
  end
end
