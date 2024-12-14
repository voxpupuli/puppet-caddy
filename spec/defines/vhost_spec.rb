# frozen_string_literal: true

require 'spec_helper'

describe 'caddy::vhost', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with source' do
        let(:title) { 'example1' }
        let(:params) { { source: 'puppet:///modules/caddy/etc/caddy/config/example1.conf' } }

        it do
          expect(subject).to contain_file('/etc/caddy/config/example1.conf').with(
            'ensure' => 'file',
            'source' => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
            'mode' => '0444',
            'require' => 'Class[Caddy::Config]',
            'notify' => 'Class[Caddy::Service]'
          )
        end
      end

      context 'with content' do
        let(:title) { 'example2' }
        let(:params) { { content: 'localhost:2015' } }

        it do
          expect(subject).to contain_file('/etc/caddy/config/example2.conf').with(
            'ensure' => 'file',
            'content' => 'localhost:2015',
            'mode' => '0444',
            'require' => 'Class[Caddy::Config]',
            'notify' => 'Class[Caddy::Service]'
          )
        end
      end

      context 'with ensure => absent' do
        let(:title) { 'example3' }
        let(:params) { { ensure: 'absent' } }

        it { expect(subject).to contain_file('/etc/caddy/config/example3.conf').with_ensure('absent') }
      end
    end
  end
end
