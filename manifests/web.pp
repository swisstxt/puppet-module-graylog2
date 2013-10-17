class graylog2::web (
  $service_alias   = $::fqdn,
  $ldap_enable     = false,
  $ldap_host       = undef,
  $ldap_port       = '636',
  $ldap_tls        = true,
  $ldap_user_dn_pattern = undef,
  $ldap_search_filter = undef,
  $ldap_bind_user  = undef,
  $ldap_bind_pass  = undef,
  $ldap_base_dn    = undef   
){
  case $osfamily {
    Debian: {
      include ::graylog2::web::debian
    }
    # default redhat to not break anything
    default: {
      include ::graylog2::web::centos
    }
  }
}
