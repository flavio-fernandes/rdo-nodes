$deps = [ 'wget', 
          'kernel-devel',
          'emacs',
]

$hosts = hiera('hosts')

file { '/etc/hosts':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('/vagrant/puppet/templates/hosts.erb'),
}

file { '/etc/init.d/vboxadd-setuptrigger':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    content => template('/vagrant/puppet/templates/vboxadd-setuptrigger.erb'),
}

exec { 'Vbox Add Setup Trigger Service':
    command => '/sbin/chkconfig --add vboxadd-setuptrigger',
    cwd     => '/etc/init.d',
    path    => $::path,
    user    => 'root',
    require => File['/etc/init.d/vboxadd-setuptrigger'],
    onlyif  => ['/usr/bin/test -f /etc/init.d/vboxadd'],
}

package { $deps:
    ensure => installed,
}

exec { 'Yum Update':
    command => 'yum update -y',  ## FIXME
    ## command => 'yum install -y emacs',
    cwd     => '/home/vagrant',
    path    => $::path,
    user    => 'root',
    require => Package[$deps],
    timeout => 0,
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

# NetworkManager is a pain
exec { 'Stop NetworkManager':
  command  => "/bin/systemctl stop NetworkManager",
  user     => 'root',
  before   => Exec['Disable NetworkManager'],
}
exec { 'Disable NetworkManager':
  command  => "/bin/systemctl disable NetworkManager",
  user     => 'root',
}
#yum::package { 'NetworkManager':
#  ensure   => absent,
#  require  => Exec['Disable NetworkManager'],
#}
exec { 'Remove NetworkManager':
  command  => "/bin/yum erase -y NetworkManager",
  user     => 'root',
  require  => Exec['Disable NetworkManager'],
}

