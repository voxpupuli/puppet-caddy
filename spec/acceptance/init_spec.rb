require 'spec_helper_acceptance'

describe 'class caddy:' do
  context 'with defaults:' do
    it 'runs successfully' do
      pp = 'include ::caddy'

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to match(%r{error}i)
      end
    end
    it 'runs without changes' do
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.exit_code).to be_zero
      end
    end
  end
  context 'with vhosts' do
    it 'runs successfully' do
      pp = "include ::caddy
            caddy::vhost {'example1':
              source => 'puppet:///modules/caddy/etc/caddy/config/example1.conf',
            }
            caddy::vhost {'example2':
              source => 'puppet:///modules/caddy/etc/caddy/config/example2.conf',
            }"
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to match(%r{error}i)
      end
    end
    it 'runs without changes' do
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.exit_code).to be_zero
      end
    end
  end
end
