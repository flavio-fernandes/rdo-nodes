# RDO-NODES

This repo provides a Vagrantfile with provisioning that one can use to quickly
get a cluster of nodes configured with RDO and packstack.

##Pre-requisites:

**Generate ssh keys! See: dotSshDir/id_rsa.erb.README**

### [Vagrant][0] (and a hypervisor, like Virtual Box)

### [Vagrant Reload Provisioner][1]

As part of the provisioning, the vms are expected to be rebooted. In order to accomplish that,
we require the vagrant's reload plugin. Install this by issuing the following command:

    $ vagrant plugin install vagrant-reload

### Number of compute nodes

If you would like more than one compute node, you can set the following environment variable:

**Note: Only 3 or less nodes are supported today. Use 0 if you want no compute nodes.**

    $ export RDO_NUM_COMPUTE_NODES=3
    $ vagrant up

At this point, the nodes will be ready to run the [packstack][2] command after 'vagrant up'.
Further work will be done to take the setup further from that. Stay tuned! ;)

[0]: https://www.vagrantup.com/ "Vagrant"
[1]: https://github.com/aidanns/vagrant-reload "Vagrant Reload"
[2]: https://openstack.redhat.com/Quickstart "Packstack"
