require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker-rspec/helpers/serverspec'

logger.info("LOADED Spec Acceptance Helper")
install_puppet_agent_on(hosts, options)

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation
  c.before :suite do

    puppet_module_install(source: proj_root, module_name: 'caddy')
  end
end
