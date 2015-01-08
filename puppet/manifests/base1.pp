$deps = [ 'git',
]

package { $deps:
    ensure   => installed,
}

vcsrepo { '/vagrant/puppet/modules/yum':
    ensure   => present,
    provider => git,
    user     => 'vagrant',
    source   => 'git://github.com/purpleidea/puppet-yum',
    revision => '74603be28b00a5336e2341d117b407bcbecbc417',
    require  => Package['git'],
}
