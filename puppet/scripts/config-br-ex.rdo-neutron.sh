cp ../templates/ifcfg-br-ex.rdo-neutron.erb /etc/sysconfig/network-scripts/ifcfg-br-ex

cat ../templates/ifcfg-enp0s9.rdo-neutron.erb > /etc/sysconfig/network-scripts/ifcfg-enp0s9

ovs-vsctl add-port br-ex enp0s9 ; systemctl restart network.service
hostnamectl set-hostname rdo-neutron
route add default gw 192.168.111.254 br-ex



