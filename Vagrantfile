hosts = [
  { name: 'dev1', hostname: 'centos7', ip: '192.168.33.108', box: 'centos/7' },
  { name: 'dev2', hostname: 'centos6', ip: '192.168.33.109', box: 'centos/6' }
]


Vagrant.configure('2') do |config|
  hosts.each do |host|
    config.vm.define host[:name] do |c|
      c.puppet_install.puppet_version = :latest
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
