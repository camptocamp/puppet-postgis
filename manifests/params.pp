class postgis::params {

  validate_re($::postgresql::version, '\S+')
  $default_version = $::postgresql::version

}
