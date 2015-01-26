$hosts = hiera('hosts')


exec { "Download RDO":
    command => "wget https://rdo.fedorapeople.org/rdo-release.rpm",
    cwd     => "/home/vagrant",
    creates => "/home/vagrant/rdo-release.rpm",
    path    => $::path,
    user    => 'vagrant',
}

package { 'rdo-release':
    ensure   => installed,
    provider => rpm,
    source   => "/home/vagrant/rdo-release.rpm",
    require  => Exec['Download RDO'],
}

package { 'openstack-packstack':
    ensure   => installed,
    require  => Package['rdo-release'],
}

exec { 'Yum Update':
   command => 'yum update -y',
   cwd     => '/home/vagrant',
   path    => $::path,
   user    => 'root',
   require => Package['openstack-packstack'],
   timeout => 0,
}

