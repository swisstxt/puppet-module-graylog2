class graylog2::server::debian {
  
  

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
  file{'/etc/graylog2/graylog2.conf':
    content => template($::graylog2::server::graylog_conf),
    owner   => root,
    group   => root,
    mode    => '0444',
  }->
  # create a symlink to the default config, since start-stop-deamon -f /etc/graylog2/graylog2.conf (-f option) wont do anything
  file { '/etc/graylog2.conf':
    ensure => 'link',
    target => '/etc/graylog2/graylog2.conf',
  }

  ~>
  file{'/etc/graylog2/elasticsearch.yml':
    content => template($::graylog2::server::graylog_elasticsearch_conf),
    owner   => root,
    group   => root,
    mode    => '0444',
  }->
  # create a symlink to the default config, since start-stop-deamon -f /etc/graylog2/graylog2.conf (-f option) wont do anything
  file { '/etc/graylog2-elasticsearch.yml':
    ensure => 'link',
    target => '/etc/graylog2/elasticsearch.yml',
  }~>
  service{'graylog2-server':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
