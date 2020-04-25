require 'spec_helper'

describe 'caddy::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('/etc/ssl/caddy/.caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755',
            'require' => 'User[caddy]'
          )
        end
        it do
          is_expected.to contain_file('/var/log/caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755',
            'require' => 'User[caddy]'
          )
        end
        it do
          is_expected.to contain_file('/etc/caddy').with(
            'ensure'  => 'directory',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0755'
          )
        end
        it do
          is_expected.to contain_file('/etc/caddy/Caddyfile').with(
            'ensure'  => 'file',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0444',
            'source'  => 'puppet:///modules/caddy/etc/caddy/Caddyfile',
            'require' => 'File[/etc/caddy]'
          )
        end
        it do
          is_expected.to contain_file('/etc/caddy/config').with(
            'ensure'  => 'directory',
            'purge'   => 'true',
            'recurse' => 'true',
            'owner'   => 'caddy',
            'group'   => 'caddy',
            'mode'    => '0755',
            'require' => 'User[caddy]'
          )
        end
      end
    end
  end
end
