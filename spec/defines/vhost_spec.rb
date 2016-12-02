require 'spec_helper'
describe 'caddy::vhost', type: :define do
  context 'with source' do
    let(:pre_condition) do
      'class { "caddy::config":
                            install_path  => "/usr/bin",
                            caddy_user    => "caddy",
                            caddy_log_dir => "/var/log/caddy",}'
    end

    let(:facts) do
      {
        os: { family: 'RedHat', release: { major: '6' } },
        caddy_user: 'caddy'
      }
    end
    let(:title) { 'example1' }
    let(:params) do
      {
        source: 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
        caddy_user: 'caddy'
      }
    end
    it do
      is_expected.to contain_file('/etc/caddy/config/example1.conf').with(
        'ensure'  => 'file',
        'source'  => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
        'mode'    => '0444',
        'owner'   => 'caddy',
        'group'   => 'caddy',
        'require' => 'Class[Caddy::Config]',
        'notify'  => 'Class[Caddy::Service]'
      )
    end
  end
  context 'with content' do
    let(:pre_condition) do
      'class { "caddy::config":
                            install_path  => "/usr/bin",
                            caddy_user    => "caddy",
                            caddy_log_dir => "/var/log/caddy",}'
    end

    let(:facts) do
      {
        os: { family: 'RedHat', release: { major: '6' } },
        caddy_user: 'caddy'
      }
    end
    let(:title) { 'example2' }
    let(:params) do
      {
        content: 'localhost:2015',
        caddy_user: 'caddy'
      }
    end
    it do
      is_expected.to contain_file('/etc/caddy/config/example2.conf').with(
        'ensure'  => 'file',
        'content' => 'localhost:2015',
        'mode'    => '0444',
        'owner'   => 'caddy',
        'group'   => 'caddy',
        'require' => 'Class[Caddy::Config]',
        'notify'  => 'Class[Caddy::Service]'
      )
    end
  end
end
