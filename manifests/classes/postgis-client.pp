/*

==Class: postgis::client

This class installs pgsql2shp and shp2pgsql which are part of
the postgis package.

The idea is that stuff defined in this class should not depend
on the whole postgresql server suite.

*/
class postgis::client {

  package { "postgis":
    ensure => present,
  }

}
