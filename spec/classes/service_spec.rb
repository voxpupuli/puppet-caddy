require 'spec_helper'

describe 'caddy::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_service('caddy').with(
            'ensure' => 'running',
            'enable' => 'true'
          )
        end
      end
    end
  end
end
