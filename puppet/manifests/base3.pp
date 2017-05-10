$deps = [ 'wget'
]

$hosts = hiera('hosts')

package { $deps:
    ensure => installed,
}

file { "/etc/resolv.conf":
  ensure => "file",
  owner  => "root",
  group  => "root",
  mode   => 644,
  content => template('/vagrant/puppet/templates/resolv.conf.erb'),
}

file { "/root/.ssh":
  ensure => "directory",
  owner  => "root",
  group  => "root",
  mode   => 700,
}

file { "/root/.ssh/id_rsa":
  ensure => "file",
  owner  => "root",
  group  => "root",
  mode   => 600,
  content => template('/vagrant/puppet/templates/dotSshDir/id_rsa.erb'),
  require => File["/root/.ssh"],
}

file { "/root/.ssh/id_rsa.pub":
  ensure => "file",
  owner  => "root",
  group  => "root",
  mode   => 644,
  content => template('/vagrant/puppet/templates/dotSshDir/id_rsa.erb.pub'),
  require => File["/root/.ssh"],
}

file { "/root/.ssh/authorized_keys":
  ensure => "file",
  owner  => "root",
  group  => "root",
  mode   => 600,
  content => template('/vagrant/puppet/templates/dotSshDir/id_rsa.pub.erb'),
  require => File["/root/.ssh"],
}
