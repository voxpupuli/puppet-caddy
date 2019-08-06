require 'spec_helper'
describe 'caddy::service' do
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
    it { is_expected.to contain_service('caddy') }
  end
end
