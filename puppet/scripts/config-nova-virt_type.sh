
cp /etc/nova/nova.conf{,.orig}
crudini --set /etc/nova/nova.conf libvirt virt_type qemu
diff /etc/nova/nova.conf{,.orig}

openstack-service restart openstack-nova-compute

crudini --get /etc/nova/nova.conf libvirt virt_type


