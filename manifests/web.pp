class graylog2::web {
  include apache

  class{'passenger':
    base => 'opt-ruby-1.9.3',
  }
  package{'graylog2-web-interface':
    ensure => present,
  }
}
