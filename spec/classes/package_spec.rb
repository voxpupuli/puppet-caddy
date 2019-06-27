require 'spec_helper'
describe 'caddy::package' do
  context 'with default values for all parameters' do
    let(:facts) do
      { osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemmajrelease: '6',
        architecture: 'x86_64'
      }
      {
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu',
        operatingsystemmajrelease: '18.04',
        architecture: 'x86_64'
      }
    end

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
