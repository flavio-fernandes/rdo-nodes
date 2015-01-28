$hosts = hiera('hosts')

file { '/root/answers.txt':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0666,
    content => template('/vagrant/puppet/templates/answers.txt.erb'),
}

file { '/root/answers.txt.orig':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0666,
    content => template('/vagrant/puppet/templates/answers.txt.orig.erb'),
}

file { '/home/vagrant/keystonerc_user1':
    ensure  => file,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 0644,
    content => template('/vagrant/puppet/templates/keystonerc_user1.erb'),
}

file { '/home/vagrant/keystonerc_user2':
    ensure  => file,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 0644,
    content => template('/vagrant/puppet/templates/keystonerc_user2.erb'),
}

file { '/root/openstack_part0.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0700,
    content => template('/vagrant/puppet/templates/openstack_part0.sh.erb'),
}

file { '/root/openstack_part1.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0777,
    content => template('/vagrant/puppet/templates/openstack_part1.sh.erb'),
}

file { '/home/vagrant/openstack_part2.sh':
    ensure  => file,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 0755,
    content => template('/vagrant/puppet/templates/openstack_part2.sh.erb'),
}

file { '/home/vagrant/openstack_part3.sh':
    ensure  => file,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 0755,
    content => template('/vagrant/puppet/templates/openstack_part3.sh.erb'),
}

