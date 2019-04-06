require 'spec_helper'

describe 'caddy', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      os_name      = facts[:os]['name']
      os_release   = facts[:os]['release']['major']

      case "#{os_name}-#{os_release}"
      when 'CentOS-6'
        let(:facts) { facts }
      else
        let(:facts) do
          facts.merge(
            service_provider: 'systemd'
          )
        end
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('caddy::package').that_comes_before('Class[caddy::config]') }
      it { is_expected.to contain_class('caddy::config').that_notifies('Class[caddy::service]') }
      it { is_expected.to contain_class('caddy::service') }

      describe 'caddy::package' do
        context 'with default values for all parameters' do
          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_exec('install caddy')
          end
          it do
            is_expected.to contain_exec('extract caddy')
          end
          it do
            is_expected.to contain_file('/usr/local/bin/caddy').with(
              'mode'    => '0755',
              'owner'   => 'root',
              'group'   => 'root',
              'require' => 'Exec[extract caddy]'
            )
          end
        end
      end

      describe 'caddy::config' do
        case "#{os_name}-#{os_release}"
        when 'CentOS-6'
          context 'with default values for Redhat family release 6' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file('/etc/caddy') }
            it { is_expected.to contain_file('/etc/caddy/Caddyfile') }
            it { is_expected.to contain_file('/etc/caddy/config') }
            it { is_expected.to contain_file('/var/log/caddy') }
            it { is_expected.to contain_user('caddy') }
            it { is_expected.to contain_group('caddy') }
            it { is_expected.to contain_file('/etc/init.d/caddy') }
          end
        when 'CentOS-7'
          context 'with default values for Redhat family release 7' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file('/etc/systemd/system/caddy.service') }
            it { is_expected.to contain_file('/etc/systemd/system/caddy.service').that_notifies(['Exec[systemctl-daemon-reload]']) }
            it do
              is_expected.to contain_exec('systemctl-daemon-reload').with(
                refreshonly: 'true',
                path: '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
                command: 'systemctl daemon-reload'
              )
            end
          end
        end
      end
    end
  end
end
