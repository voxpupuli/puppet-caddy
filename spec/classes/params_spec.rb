require 'spec_helper'
describe 'caddy::params' do
  context 'with default values for Debian family, Ubuntu 18.04' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu',
        operatingsystemmajrelease: '18.04',
        architecture: 'x86_64'
      }
    end
  it { is_expected.to compile.with_all_deps }
  end
end
