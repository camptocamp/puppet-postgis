/*

==Class: postgis::debian::v8-4

Requires:
 - Class["apt::preferences"]

*/
class postgis::debian::v8-4 inherits postgis::debian::base {
  
  if $lsbdistcodename == "lenny" {
    apt::preferences {"postgresql-8.4-postgis":
      pin => "release a=${lsbdistcodename}-backports",
      priority => "1100"
    }
  }

  case $lsbdistcodename {
    "lenny" : { 
      Package["postgis"] {
        name => "postgresql-8.4-postgis"
      }
    }

    default: {
      fail "postgresql-postgis 8.4 not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }
}
