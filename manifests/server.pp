class graylog2::server {
  include mongodb

  class{'elasticsearch':
    config => {
      'node.name'    => 'graylog2',
      'network.host' => 'localhost',
    },
  }->
  mongodb::mongod{'graylog2':
    mongod_instance => "graylog2",
  }->
  package{'graylog2-server':
    ensure => present,
  }->
  service{'graylog2-server':
    ensure => running,
    enable => true,
    hasstatus => true,
  }
}
