$deps = [ 'wget', 
          'kernel-devel',
]

$hosts = hiera('hosts')

file { '/etc/hosts':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('/vagrant/puppet/templates/hosts.erb'),
}

file { '/etc/init.d/vboxadd_setuptrigger':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    content => template('/vagrant/puppet/templates/vboxadd_setuptrigger.erb'),
}

exec { 'Vbox Add Setup Trigger Service':
    command => '/sbin/chkconfig --add vboxadd_setuptrigger',
    cwd     => '/etc/init.d',
    path    => $::path,
    user    => 'root',
    require => File['/etc/init.d/vboxadd_setuptrigger'],
    onlyif  => ['/usr/bin/test -f /etc/init.d/vboxadd'],
}

package { $deps:
    ensure => installed,
}

exec { 'Yum Update':
    command => 'yum update -y',
    cwd     => '/home/vagrant',
    path    => $::path,
    user    => 'root',
    require => Package[$deps],
}

# http://projects.puppetlabs.com/issues/5175
yum::package { '@Development tools':
   ensure => installed,
   require  => Exec['Yum Update'],
}

# http://puppetcookbook.com/posts/exec-onlyif.html
exec { 'VboxAdd Setup':
  command  => "/bin/touch vboxadd_setup_is_needed",
  cwd      => '/home/vagrant',
  path     => $::path,
  user     => 'vagrant',
  onlyif   => [ '/usr/bin/test -f /etc/init.d/vboxadd' ],
  require  => Yum::Package['@Development tools'],
}
