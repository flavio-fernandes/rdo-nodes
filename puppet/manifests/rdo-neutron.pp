$hosts = hiera('hosts')

# http://docs.openstack.org/juno/install-guide/install/yum/content/neutron-network-node.html
# cat /proc/sys/net/ipv4/ip_forward
file { '/etc/sysctl.d/90-rdo-neutron.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template('/vagrant/puppet/templates/sysctl.d-rdo-neutron.conf.erb'),
    before  => Exec['Update sysctl.d'],
}
exec { 'Update sysctl.d':
  command  => "/sbin/sysctl -p /etc/sysctl.d/90-rdo-neutron.conf",
  user     => 'root',
}

