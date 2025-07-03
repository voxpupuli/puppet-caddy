# frozen_string_literal: true

require 'spec_helper_acceptance'

# rubocop:disable RSpec/RepeatedExampleGroupDescription
describe 'class caddy:' do
  # The default configuration download the latest available release. In order to
  # avoid to maintain the test suite to match each release, query GitHub API to
  # find the last release.
  let(:latest_release) { GithubHelpers.latest_release('caddyserver/caddy') }

  # Guess latest packaged version in the repo by OS facts
  def repo_version(os_facts, latest_release)
    case [os_facts['family'], os_facts['release']['major']]
    when %w[Debian]
      '2.8.3'
    when %w[RedHat 8]
      '2.9.1'
    else
      latest_release.sub(%r{\Av}, '')
    end
  end

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
    let(:github_version) { '2.9.1' }

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
            install_method => 'github',
            version        => '#{github_version}',
          }
        PUPPET
      end
    end

    describe command('/opt/caddy/caddy version') do
      its(:stdout) { is_expected.to start_with "v#{github_version}" }
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
    let(:use_version) { repo_version(fact('os'), latest_release) }

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
            install_method => 'repo',
            package_ensure => '#{use_version}',
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

  context 'with apache-like layout' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'caddy':
            config_dir => '/etc/caddy/conf-available',
            config_enable_dir => '/etc/caddy/conf-enabled',
            vhost_dir => '/etc/caddy/sites-available',
            vhost_enable_dir => '/etc/caddy/sites-enabled',
            config_file_extension => '.caddyfile',
            config_files => {
              admin_2020 => {
                content => "{\n  admin localhost:2020\n}\n",
              },
              admin_2021 => {
                ensure => 'disabled',
                content => "{\n  admin localhost:2021\n}\n",
              },
            },
            vhosts => {
              port_3000 => {
                content => "http://localhost:3000 {\n  respond \\"port 3000 ok\\"\n}\n",
              },
              port_3001 => {
                ensure => 'disabled',
                content => "http://localhost:3001 {\n  respond \\"port 3001 disabled\\"\n}\n",
              }
            }
          }
        PUPPET
      end
    end

    describe command('curl -v http://localhost:2020/config/admin') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to eq "{\"listen\":\"localhost:2020\"}\n" }
    end

    describe port(2021) do # rubocop:disable RSpec/RepeatedExampleGroupBody
      it { is_expected.not_to be_listening }
    end

    describe command('curl -v http://localhost:3000/') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to eq 'port 3000 ok' }
    end

    describe port(3001) do # rubocop:disable RSpec/RepeatedExampleGroupBody
      it { is_expected.not_to be_listening }
    end
  end
end
# rubocop:enable RSpec/RepeatedExampleGroupDescription
