# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'class caddy:' do
  context 'with default settings' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
          }
        PUPPET
      end
    end
  end

  context 'when installing from GitHub' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
            install_method => 'github',
          }
        PUPPET
      end
    end
  end

  context 'with vhosts' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
          }

          caddy::vhost {'example1':
            source => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
          }

          caddy::vhost {'example2':
            source => 'puppet:///modules/caddy/etc/caddy/config/example2.conf',
          }
        PUPPET
      end
    end
  end
end
