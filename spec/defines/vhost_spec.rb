require 'spec_helper'

describe 'caddy::vhost', type: :define do
  on_supported_os.each do |os, facts|
    svcpro =  case facts[:os]['release']['major']
              when '6'
                'redhat'
              else
                'systemd'
              end

    context "on #{os}" do
      let(:facts) do
        facts.merge(service_provider: svcpro) # factordb doesn't provide service_provider
      end

      let(:pre_condition) { 'include caddy' }

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
            'mode'    => '0444',
            'require' => 'Class[Caddy::Config]',
            'notify'  => 'Class[Caddy::Service]'
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
            'mode'    => '0444',
            'require' => 'Class[Caddy::Config]',
            'notify'  => 'Class[Caddy::Service]'
          )
        end
      end
    end
  end
end
