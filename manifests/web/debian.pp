class graylog2::web::debian {
  
  #class{'passenger':
  #  base => 'opt-ruby-1.9.3',
  #}
  # TODO => do this via passenger module
  package{'libapache2-mod-passenger':
    ensure => present,
  }
  file{'/etc/apache2/conf.d/passenger.conf':
    source  => 'puppet:///modules/graylog2/passenger.debian.conf',
    owner   => root,
    group   => 0,
    mode    => '0644',
    require => Package['libapache2-mod-passenger'];
  }
  
  package{'bundler':
    ensure => present,
  }
  package{'graylog2-web':
    ensure  => present,
    notify  => [
      Exec['graylog2_bundle_deploy'],
    ],
    require => [
      Package['bundler'],
      Package['libapache2-mod-passenger'],
    ];
  }
  # are the gems wrong deployed in the RPM?
  exec{'graylog2_bundle_deploy':
    cwd         => '/var/www/graylog2-web/',
    command     => '/usr/bin/bundle --deployment',
    refreshonly => true;
  }
  
  file{'/etc/apache2/conf.d/graylog2-web.conf':
    source  => "puppet:///modules/${module_name}/graylog2-web-interface-debian.conf",
    owner   => root,
    group   => root,
    mode    => '0444',
    notify  => Service['httpd'],
    require => Package['graylog2-web'];
  }
  file{'/var/www/graylog2-web/config/general.yml':
    content => template('graylog2/general.yml.erb'),
    owner   => root,
    group   => 0,
    mode    => '0644',
    notify  => Service['httpd'],
    require => Package['graylog2-web'];
  }
  file{'/var/www/graylog2-web/config/indexer.yml':
    source  => 'puppet:///modules/graylog2/indexer.yml',
    owner   => root,
    group   => 0,
    mode    => '0644',
    notify  => Service['httpd'],
    require => Package['graylog2-web'];
  }
  file{'/var/www/graylog2-web/config/ldap.yml':
    content => template('graylog2/ldap.yml.erb'),
    owner   => root,
    group   => 0,
    mode    => '0644',
    notify  => Service['httpd'],
    require => Package['graylog2-web'];
  }
   

}
