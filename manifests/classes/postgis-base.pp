/*

==Class: postgis::base

This class is dedicated to the common parts 
shared by the different distributions

*/
class postgis::base {

  include postgis::client

  # this package is declined in different postgresql-<version>-postgis
  # packages depending on the distribution.
  # It contains stuff such as spatial_ref_sys.sql and libpostgis.so.
  package { "postgresql-postgis":
    ensure  => present,
    require => Postgresql::Cluster["main"],
  }

}
