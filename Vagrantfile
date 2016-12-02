hosts = [
  { name: 'dev1', hostname: 'centos7', ip: '192.168.33.108', box: 'centos7.2' },
  { name: 'dev2', hostname: 'centos6', ip: '192.168.33.109', box: 'centos6.8' }
]

# Check required plugins
required_plugins = ['vagrant-puppet-install', 'vagrant-vbguest']

required_plugins.each do |plugin|
  system("vagrant plugin install #{plugin}") unless Vagrant.has_plugin?(plugin)
end

Vagrant.configure('2') do |config|
  hosts.each do |host|
    config.vm.define host[:name] do |c|
      c.puppet_install.puppet_version = :latest
      c.vbguest.auto_update = false
      c.ssh.insert_key = false
      c.vm.box = host[:box]
      c.vm.hostname = host[:hostname]
      c.vm.synced_folder '.', '/etc/puppetlabs/code/environments/production/modules/caddy/'
      c.vm.network :private_network, ip: host[:ip], netmask: '255.255.255.0'
      c.vm.provider :virtualbox do |vb|
        vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      end
    end
  end
end
