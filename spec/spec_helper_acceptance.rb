# frozen_string_literal: true

# Managed by modulesync - DO NOT EDIT
# https://voxpupuli.org/docs/updating-files-managed-with-modulesync/

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker(modules: :metadata) do |host|
  case fact_on(host, 'os.family')
  when 'Debian'
    install_puppet_module_via_pmt_on(host, 'puppetlabs-apt')
  when 'RedHat'
    install_puppet_module_via_pmt_on(host, 'puppet-yum')
  end
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
