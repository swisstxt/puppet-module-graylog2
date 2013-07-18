class graylog2::web {
  include apache

  #class{'passenger':
  #  base => 'opt-ruby-1.9.3',
  #}
  # TODO => do this via passenger module
  package{'opt-ruby-1.9.3-mod_passenger':
    ensure => present,
  }
  package{'opt-ruby-1.9.3-rubygem-bundler':
    ensure => present,
  }
  package{'graylog2-web-interface':
    ensure => present,
  }
  file{'/etc/httpd/conf.d/graylog2-web-interface.conf':
    source => "puppet:///modules/${module_name}/graylog2-web-interface.conf",
    owner  => root,
    group  => root,
    mode   => 0444,
    notify => Class['::apache::service'],
  }
}
