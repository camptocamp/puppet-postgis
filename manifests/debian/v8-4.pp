/*

==Class: postgis::debian::v8-4

Requires:
 - Class["apt::preferences"]

*/
class postgis::debian::v8-4 inherits postgis::debian::base {
  
  case $lsbdistcodename {
    "lenny", "squeeze" : {
      Package["postgresql-postgis"] {
        name => "postgresql-8.4-postgis"
      }
    }

    default: {
      fail "postgresql-postgis 8.4 not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }
}
