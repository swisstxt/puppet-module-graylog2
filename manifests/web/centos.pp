class graylog2::web::centos {
  include apache
  
  #class{'passenger':
  #  base => 'opt-ruby-1.9.3',
  #}
  # TODO => do this via passenger module
  package{'opt-ruby-1.9.3-mod_passenger':
    ensure => present,
  }
  file{'/etc/httpd/conf.d/passenger.conf':
    source  => 'puppet:///modules/graylog2/passenger.conf',
    owner   => root,
    group   => 0,
    mode    => '0644',
    require => Package['opt-ruby-1.9.3-mod_passenger'];
  }

  package{'opt-ruby-1.9.3-rubygem-bundler':
    ensure => present,
  }
  package{'graylog2-web-interface':
    ensure  => present,
    notify  => [
      Exec['graylog2_bundle_deploy'],
      Exec['graylog2_chown_workaround']
    ],
    require => [
      Package['opt-ruby-1.9.3-rubygem-bundler'],
      Package['opt-ruby-1.9.3-mod_passenger'],
    ];
  }
  # are the gems wrong deployed in the RPM?
  exec{'graylog2_bundle_deploy':
    cwd         => '/var/www/vhosts/graylog2-web-interface/',
    command     => '/opt/ruby-1.9.3/bin/bundle --deployment',
    refreshonly => true;
  }
  exec{'graylog2_chown_workaround':
    cwd         => '/var/www/vhosts/graylog2-web-interface/',
    command     => 'chown -R apache:apache tmp log vendor',
    refreshonly => false;
  }
  exec{'graylog2_chmod_workaround':
    cwd         => '/var/www/vhosts/graylog2-web-interface/',
    command     => 'chmod 0777 tmp log',
    refreshonly => false;
  }

  file{'/etc/httpd/conf.d/graylog2-web-interface.conf':
    source  => "puppet:///modules/${module_name}/graylog2-web-interface.conf",
    owner   => root,
    group   => root,
    mode    => '0444',
    notify  => Service['httpd'],
    require => Package['graylog2-web-interface'];
  }
  file{'/var/www/vhosts/graylog2-web-interface/config/general.yml':
    content => template('graylog2/general.yml.erb'),
    owner   => root,
    group   => 0,
    mode    => '0644',
    notify  => Service['httpd'],
    require => Package['graylog2-web-interface'];
  }
  file{'/var/www/vhosts/graylog2-web-interface/config/indexer.yml':
    source  => 'puppet:///modules/graylog2/indexer.yml',
    owner   => root,
    group   => 0,
    mode    => '0644',
    notify  => Service['httpd'],
    require => Package['graylog2-web-interface'];
  }
  file{'/var/www/vhosts/graylog2-web-interface/config/ldap.yml':
    content => template('graylog2/ldap.yml.erb'),
    owner   => root,
    group   => 0,
    mode    => '0644',
    notify  => Service['httpd'],
    require => Package['graylog2-web-interface'];
  }
   

}
