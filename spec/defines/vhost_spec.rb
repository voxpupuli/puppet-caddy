require 'spec_helper'
describe 'caddy::vhost', type: :define do
  context 'with source' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: { major: '6' },
          architecture: 'x86_64'
        }
      }
    end
    let(:pre_condition) { 'include ::caddy' }
    let(:title) { 'example1' }
    let(:params) do
      {
        source: 'puppet:///modules/caddy/etc/caddy/config/example1.conf'
      }
    end

    it do
      is_expected.to contain_file('/etc/caddy/config/example1.conf').with(
        'ensure'  => 'file',
        'source'  => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
        'mode'    => '0444',
        'require' => 'Class[Caddy::Config]',
        'notify'  => 'Class[Caddy::Service]'
      )
    end
  end
  context 'with content' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: { major: '6' },
          architecture: 'x86_64'
        }
      }
    end
    let(:title) { 'example2' }
    let(:pre_condition) { 'include ::caddy' }
    let(:params) do
      {
        content: 'localhost:2015'
      }
    end

    it do
      is_expected.to contain_file('/etc/caddy/config/example2.conf').with(
        'ensure'  => 'file',
        'content' => 'localhost:2015',
        'mode'    => '0444',
        'require' => 'Class[Caddy::Config]',
        'notify'  => 'Class[Caddy::Service]'
      )
    end
  end
end
