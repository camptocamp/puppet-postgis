/*

==Class: postgis::base

This class is dedicated to the common parts 
shared by the different distributions

*/
class postgis::base {

  package {"postgis":
    ensure => present,
    require => Package["postgresql"],
  }                                      
  
}
