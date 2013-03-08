class graylog2::server(
  $graylog_conf = 'graylog2/graylog2.conf.erb',
  $graylog_elasticsearch_conf = 'graylog2/graylog2-elasticsearch.yml.erb'
){
  include mongodb

  class{'elasticsearch':
    config => {
      'node.name'    => 'graylog2-node',
      'network.host' => 'localhost',
      'cluster.name' => 'graylog2',
    },
  }->
  mongodb::mongod{'graylog2':
    mongod_instance => "graylog2",
  }->
  package{'graylog2-server':
    ensure => present,
  }->
  file{'/etc/graylog2.conf':
    content => template($graylog_conf),
    owner   => root,
    group   => root,
    mode    => '0444',
  }~>
  file{'/etc/graylog2-elasticsearch.yml':
    content => template($graylog_elasticsearch_conf),
    owner   => root,
    group   => root,
    mode    => '0444',
  }~>
  service{'graylog2-server':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
