require 'spec_helper'

describe 'caddy::package' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_exec('install caddy').with(
            'command' => 'curl -o /tmp/caddy_linux_amd64_custom.tar.gz \'https://caddyserver.com/download/linux/amd64?plugins=http.filter,http.git,http.ipfilter&license=personal&telemetry=off\'',
            'creates' => '/usr/local/bin/caddy'
          )
        end
        it do
          is_expected.to contain_exec('extract caddy').with(
            'command' => 'tar -zxf /tmp/caddy_linux_amd64_custom.tar.gz -C /usr/local/bin \'caddy\'',
            'creates' => '/usr/local/bin/caddy',
            'require' => 'Exec[install caddy]'
          )
        end
        it do
          is_expected.to contain_file('/usr/local/bin/caddy').with(
            'mode'    => '0755',
            'owner'   => 'root',
            'group'   => 'root',
            'notify'  => 'Exec[set cap caddy]',
            'require' => 'Exec[extract caddy]'
          )
        end
        it do
          is_expected.to contain_exec('set cap caddy').with(
            'command'     => 'setcap cap_net_bind_service=+ep /usr/local/bin/caddy',
            'require'     => 'File[/usr/local/bin/caddy]',
            'refreshonly' => 'true'
          )
        end
      end
    end
  end
end
