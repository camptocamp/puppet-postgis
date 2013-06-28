class postgis::params {

  validate_re($::postgres_default_version, '\S+')
  $default_version = $::postgres_default_version

}
