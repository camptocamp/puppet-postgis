class postgis::params {

  include postgresql::params

  $default_version = $postgresql::params::default_version

}
