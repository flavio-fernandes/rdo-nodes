# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", path: "puppet/scripts/bootstrap.sh"

  num_compute_nodes = (ENV['RDO_NUM_COMPUTE_NODES'] || 2).to_i

  # ip configuration
  control_ip = "192.168.50.20"
  neutron_ip = "192.168.50.21"
  neutron_ex_ip = "192.168.111.11"
  compute_ip_base = "192.168.50."
  compute_ips = num_compute_nodes.times.collect { |n| compute_ip_base + "#{n+22}" }

  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      ## no module path added here, as this manifest populates the puppet modules directory
      ## puppet.module_path = "puppet/modules"
      puppet.manifest_file  = "base1.pp"
  end
  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      puppet.manifest_file  = "base2.pp"
  end

  config.vm.provision :reload

  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      puppet.manifest_file  = "base3.pp"
  end

  # Rdo Neutron
  config.vm.define "rdo-neutron", primary: false, autostart: true do |neutron|
    neutron.vm.box = "centos7"
    neutron.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
    neutron.vm.provider "vmware_fusion" do |v, override|
      override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_centos-7.0_chef-provisionerless.box"
    end
    neutron.vm.hostname = "rdo-neutron"
    neutron.vm.network "private_network", ip: "#{neutron_ip}"
    ## neutron.vm.network "private_network", type: "dhcp", virtualbox__intnet: "intnet", auto_config: false
    neutron.vm.network "private_network", ip: "#{neutron_ex_ip}", virtualbox__intnet: "mylocalnet"
    neutron.vm.provider :virtualbox do |vb|
      ## vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      vb.customize ["modifyvm", :id, "--nictype3", "virtio"]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
      vb.customize ["modifyvm", :id, "--macaddress3", "0000000000FE"]
    end
    neutron.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "1024"
    end
    neutron.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "rdo-neutron.pp"
    end
  end

  # Rdo Compute Nodes
  num_compute_nodes.times do |n|
    config.vm.define "rdo-compute-#{n+1}", autostart: true do |compute|
      compute_ip = compute_ips[n]
      compute_index = n+1
      compute.vm.box = "centos7"
      compute.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
      compute.vm.provider "vmware_fusion" do |v, override|
        override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_centos-7.0_chef-provisionerless.box"
      end
      compute.vm.hostname = "rdo-compute-#{compute_index}"
      compute.vm.network "private_network", ip: "#{compute_ip}"
      # compute.vm.network "private_network", ip: "", virtualbox__intnet: "mylocalnet", auto_config: false
      compute.vm.provider :virtualbox do |vb|
        ## vb.gui = true
        vb.customize ["modifyvm", :id, "--memory", "4096"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
        vb.customize ["modifyvm", :id, "--audio", "none"]
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
        vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
        # vb.customize ["modifyvm", :id, "--nictype3", "virtio"]
        vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
        # vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
      end
      compute.vm.provider "vmware_fusion" do |vf|
        vf.vmx["numvcpus"] = "2"
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

  # Rdo Controller
  config.vm.define "rdo-control", primary: true do |control|
    control.vm.box = "centos7"
    control.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
    control.vm.provider "vmware_fusion" do |v, override|
      override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_centos-7.0_chef-provisionerless.box"
    end
    control.vm.hostname = "rdo-control"
    control.vm.network "private_network", ip: "#{control_ip}"
    # control.vm.network "forwarded_port", guest: 8080, host: 8081
    # control.vm.network "private_network", ip: "", virtualbox__intnet: "mylocalnet", auto_config: false
    control.vm.provider :virtualbox do |vb|
      ## vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      # vb.customize ["modifyvm", :id, "--nictype3", "virtio"]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      # vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
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

end
