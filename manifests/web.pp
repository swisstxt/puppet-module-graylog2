class graylog2::web {
  include apache

  #class{'passenger':
  #  base => 'opt-ruby-1.9.3',
  #}
  # TODO => do this via passenger module
  package{'opt-ruby-1.9.3-mod_passenger':
    ensure => present,
  }
  package{'graylog2-web-interface':
    ensure => present,
  }
}
