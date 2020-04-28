require 'spec_helper'

describe 'caddy::vhost', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with source' do
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
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0444',
            'require' => 'File[/etc/caddy/Caddyfile]',
            'notify'  => 'Service[caddy]'
          )
        end
      end

      context 'with content' do
        let(:title) { 'example2' }
        let(:params) do
          {
            content: 'localhost:2015'
          }
        end

        it do
          is_expected.to contain_file('/etc/caddy/config/example2.conf').with(
            'ensure'  => 'file',
            'content' => 'localhost:2015',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0444',
            'require' => 'File[/etc/caddy/Caddyfile]',
            'notify'  => 'Service[caddy]'
          )
        end
      end
    end
  end
end
