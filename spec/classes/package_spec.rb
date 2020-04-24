require 'spec_helper'

describe 'caddy::package' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('install caddy') }
        it { is_expected.to contain_exec('extract caddy') }
        it do
          is_expected.to contain_file('/usr/local/bin/caddy').with(
            'mode'    => '0755',
            'owner'   => 'root',
            'group'   => 'root',
            'require' => 'Exec[extract caddy]'
          )
        end
        it do
          is_expected.to contain_exec('set cap caddy').with(
            command: 'setcap cap_net_bind_service=+ep /usr/local/bin/caddy',
            require: 'File[/usr/local/bin/caddy]',
            refreshonly: 'true'
          )
        end
      end
    end
  end
end
