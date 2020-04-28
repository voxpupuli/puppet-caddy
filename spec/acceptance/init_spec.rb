require 'spec_helper_acceptance'

describe 'class caddy:' do
  context 'with defaults:' do
    pp = 'include caddy'
    it 'runs successfully' do
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
    pp = "include caddy
          caddy::vhost { 'example1':
            content => file('caddy/examples/example1.conf'),
          }
          caddy::vhost { 'example2':
            content => file('caddy/examples/example2.conf'),
          }"
    it 'runs successfully' do
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
