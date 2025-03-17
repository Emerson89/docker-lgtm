# -*- mode: ruby -*-
# vi: set ft=ruby :

vms = {
'lgtm' => {'memory' => '1048', 'cpus' => '2', 'ip' => '20', 'box' => 'ubuntu/jammy64'},
#'node' => {'memory' => '2048', 'cpus' => '2', 'ip' => '11', 'box' => 'ubuntu/jammy64'},
#'k8s2' => {'memory' => '3048', 'cpus' => '4', 'ip' => '15', 'box' => 'ubuntu/focal64'},
#'almalinux-srv' => {'memory' => '2048', 'cpus' => '2', 'ip' => '12', 'box' => 'almalinux/8'},
#'oracle-srv' => {'memory' => '1048', 'cpus' => '2', 'ip' => '12', 'box' => 'bento/oracle-8.6'},
}

Vagrant.require_version '>= 1.9.0'

Vagrant.configure('2') do |config|
  vms.each do |name, conf|
     config.vm.define "#{name}" do |my|
       my.vm.box = conf['box']
       my.vm.hostname = "#{name}.example.com"
       my.vm.synced_folder ".", "/home/vagrant/kubeconfig", type: "virtualbox"
       #my.vm.disk :disk, size: "30GB", primary: true
       #my.vm.network 'private_network', ip: "172.16.3.#{conf['ip']}"
       my.vm.network 'public_network', ip: "192.168.3.#{conf['ip']}", bridge: "wlp1s0"
       my.vm.provision 'shell', path: "script.sh"
       my.vm.provider 'virtualbox' do |vb|
          vb.memory = conf['memory']
          vb.cpus = conf['cpus']
       end
     end
  end
end
