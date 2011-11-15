/*

==Class: postgis::debian::v8-3

Requires:
 - Class["apt::preferences"]

*/
class postgis::debian::v8-3 inherits postgis::debian::base {
  
  case $lsbdistcodename {
    "etch", "lenny" : { 
      Package["postgresql-postgis"] {
        name => "postgresql-8.3-postgis"
      }
    }

    default: {
      fail "postgis version not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }
}
