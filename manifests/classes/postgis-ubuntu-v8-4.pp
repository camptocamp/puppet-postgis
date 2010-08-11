/*

==Class: postgis::ubuntu::v8-4

Requires:
 - Class["apt::preferences"]

*/
class postgis::ubuntu::v8-4 inherits postgis::ubuntu::base {

  case $lsbdistcodename {
    "lucid" : { 
      Package["postgis"] {
        name => "postgresql-8.4-postgis"
      }
    }

    default: {
      fail "postgresql-postgis 8.4 not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }

}
