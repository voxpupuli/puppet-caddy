require 'spec_helper'
describe 'caddy::package' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      context 'with default values' do
        let(:facts) { os_facts }

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
            'require' => 'Exec[extract caddy]',
          )
        end
      end
    end
  end
end
