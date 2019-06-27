require 'voxpupuli/acceptance/spec_helper_acceptance'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'] =~ %r{pe}i
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
  hosts.each do |host|
    if host[:platform] =~ %r{el-7-x86_64} && host[:hypervisor] =~ %r{docker}
      on(host, "sed -i '/nodocs/d' /etc/yum.conf")
    end
    if host[:platform] =~ %r{ubuntu-18.04} && host[:hypervisor] =~ %r{docker}
      on(host, 'apt-get install -y libcap2-bin')
    end
  end
end
