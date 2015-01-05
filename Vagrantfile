# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", path: "puppet/scripts/bootstrap.sh"

  num_compute_nodes = (ENV['RDO_NUM_COMPUTE_NODES'] || 1).to_i

  # ip configuration
  control_ip = "192.168.50.20"
  compute_ip_base = "192.168.50."
  compute_ips = num_compute_nodes.times.collect { |n| compute_ip_base + "#{n+21}" }

  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      puppet.manifest_file  = "base.pp"
  end

  config.vm.provision :reload

  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      puppet.manifest_file  = "base2.pp"
  end

  # Rdo Controller
  config.vm.define "rdo-control" do |control|
    control.vm.box = "centos7"
    control.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
    control.vm.provider "vmware_fusion" do |v, override|
      override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_centos-7.0_chef-provisionerless.box"
    end
    control.vm.hostname = "rdo-control"
    control.vm.network "private_network", ip: "#{control_ip}"
    control.vm.network "forwarded_port", guest: 8080, host: 8081
    control.vm.provider :virtualbox do |vb|
      vb.memory = 4096
    end
    control.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "4096"
    end
    control.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "rdo-control.pp"
    end
  end

  # Rdo Compute Nodes
  num_compute_nodes.times do |n|
    config.vm.define "rdo-compute-#{n+1}" do |compute|
      compute_ip = compute_ips[n]
      compute_index = n+1
      compute.vm.box = "centos7"
      compute.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
      compute.vm.provider "vmware_fusion" do |v, override|
        override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_centos-7.0_chef-provisionerless.box"
      end
      compute.vm.hostname = "rdo-compute-#{compute_index}"
      compute.vm.network "private_network", ip: "#{compute_ip}"
      compute.vm.provider :virtualbox do |vb|
        vb.memory = 4096
      end
      compute.vm.provider "vmware_fusion" do |vf|
        vf.vmx["memsize"] = "4096"
      end
      compute.vm.provision "puppet" do |puppet|
        puppet.hiera_config_path = "puppet/hiera.yaml"
        puppet.working_directory = "/vagrant/puppet"
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "rdo-compute.pp"
      end
    end
  end

end
