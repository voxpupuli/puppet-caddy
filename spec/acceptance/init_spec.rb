# frozen_string_literal: true

require 'spec_helper_acceptance'

# The default configuration download the latest available release. In order to
# avoid to maintain the test suite to match each release, query GitHub API to
# find the last release.
latest_release = JSON.parse(URI.open('https://api.github.com/repos/caddyserver/caddy/releases/latest').read)['tag_name']

# rubocop:disable RSpec/RepeatedExampleGroupDescription
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

    describe command('/opt/caddy/caddy version') do
      its(:stdout) { is_expected.to start_with latest_release }
    end
  end

  context 'when installing from GitHub' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
            install_method => 'github',
            version        => '2.6.0',
          }
        PUPPET
      end
    end

    describe command('/opt/caddy/caddy version') do
      its(:stdout) { is_expected.to start_with 'v2.6.0' }
    end

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
            install_method => 'github',
            version        => '#{latest_release.sub(%r{\Av}, '')}',
          }
        PUPPET
      end
    end

    describe command('/opt/caddy/caddy version') do
      its(:stdout) { is_expected.to start_with latest_release }
    end
  end

  context 'when installing from repo' do
    # Debian repo has multiple versions
    # RedHat repo has just the latest version at the moment
    let(:use_version) do
      case fact('os.family')
      when 'Debian'
        '2.8.3'
      else
        latest_release.sub(%r{\Av}, '')
      end
    end

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
            install_method => 'repo',
            version        => '#{use_version}',
          }
        PUPPET
      end
    end

    describe command('caddy version') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to start_with "v#{use_version}" }
    end
  end

  context 'with vhosts' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
          }

          caddy::vhost {'example1':
            content => "localhost:3000 {\n  respond \\'example1\\'\n}\n"
          }

          caddy::vhost {'example2':
            source => 'puppet:///modules/caddy/etc/caddy/config/example2.conf',
          }
        PUPPET
      end
    end
  end
end
# rubocop:enable RSpec/RepeatedExampleGroupDescription
