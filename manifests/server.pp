class graylog2::server(
  $graylog_conf = 'graylog2/graylog2.conf.erb',
  $graylog_elasticsearch_conf = 'graylog2/graylog2-elasticsearch.yml.erb'
){
  include mongodb

  case $osfamily {
    'Debian': {
      include ::graylog2::server::debian
    }
    # default redhat to not break anything
    default: {
      include ::graylog2::server::centos
    }
  }
}
