require 'spec_helper'
describe 'caddy::package' do
  context 'with default values for Redhat family release 6' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: {
            major: '6'
          },
          architecture: 'x86_64'
        }
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('caddy::package') }
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
  context 'with default values for Debian family, Ubuntu 18.04' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'Ubuntu',
          release: {
            major: '18.04'
          },
          architecture: 'x86_64'
        },
        path: '/usr/bin:/usr/sbin:/bin:/usr/local/bin'
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('caddy::package') }
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
    it { is_expected.to contain_exec('set cap caddy') }
  end
end
