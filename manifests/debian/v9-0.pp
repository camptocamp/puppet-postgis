/*

==Class: postgis::debian::v9-0

Requires:
 - Class["apt::preferences"]

*/
class postgis::debian::v9-0 inherits postgis::debian::base {

  case $lsbdistcodename {
    squeeze : { 
      Package["postgresql-postgis"] {
        name => "postgresql-9.0-postgis"
      }
    }

    default: {
      fail "${name} not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }
}
