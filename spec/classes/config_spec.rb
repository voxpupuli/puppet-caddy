require 'spec_helper'

describe 'caddy::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      major = os_facts[:operatingsystemmajrelease].to_f # darn ubuntu
      usergroup = case os_facts[:osfamily]
                  when 'Debian'
                    'www-data'
                  else
                    'caddy'
                  end

      context 'with default values' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/caddy') }
        it { is_expected.to contain_file('/etc/caddy/Caddyfile') }
        it { is_expected.to contain_file('/etc/caddy/config') }
        it { is_expected.to contain_file('/var/log/caddy') }
        it { is_expected.to contain_user(usergroup) }
        it { is_expected.to contain_group(usergroup) }

        if major > 6.0
          it { is_expected.to contain_systemd__unit_file('caddy.service') }
        else
          it { is_expected.to contain_file('/etc/init.d/caddy') }
        end
      end
    end
  end
end
