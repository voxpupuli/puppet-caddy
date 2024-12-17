# frozen_string_literal: true

require 'spec_helper'

describe 'caddy::vhost', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:pre_condition) { 'class { "caddy": config_dir => "/etc/caddy/config" }' }
      let(:title) { 'example' }

      context 'with source' do
        let(:params) { { source: 'puppet:///modules/caddy/etc/caddy/config/example1.conf' } }

        it do
          is_expected.to contain_file('/etc/caddy/config/example.conf').with(
            'ensure' => 'file',
            'source' => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
            'mode' => '0444',
            'require' => 'Class[Caddy::Config]',
            'notify' => 'Class[Caddy::Service]'
          )
        end

        context 'with config_dir set' do
          let(:params) { super().merge(config_dir: '/etc/caddy/conf.d') }

          it { is_expected.to contain_file('/etc/caddy/conf.d/example.conf') }
        end

        context 'with ensure => absent' do
          let(:params) { super().merge(ensure: 'absent') }

          it { is_expected.to contain_file('/etc/caddy/config/example.conf').with_ensure('absent') }
        end

        context 'with custom title' do
          let(:title) { 'test' }

          it { is_expected.to contain_file('/etc/caddy/config/test.conf') }
        end
      end

      context 'with content' do
        let(:params) { { content: 'localhost:2015' } }

        it do
          is_expected.to contain_file('/etc/caddy/config/example.conf').with(
            'ensure' => 'file',
            'content' => 'localhost:2015',
            'mode' => '0444',
            'require' => 'Class[Caddy::Config]',
            'notify' => 'Class[Caddy::Service]'
          )
        end
      end

      context 'without source & content' do
        it { is_expected.to compile.and_raise_error(%r{Either \$source or \$content must be specified}) }
      end
    end
  end
end
