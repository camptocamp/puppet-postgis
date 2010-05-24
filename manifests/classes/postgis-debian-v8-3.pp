/*

==Class: postgis::debian::v8-3

Requires:
 - Class["apt::preferences"]

*/
class postgis::debian::v8-3 inherits postgis::debian::base {
  
  if $lsbdistcodename == "etch" {
    apt::preferences {"postgresql-8.3-postgis":
      pin => "release a=${lsbdistcodename}-backports",
      priority => "1100"
    }
  }

  case $lsbdistcodename {
    "etch", "lenny" : { 
      Package["postgis"] {
        name => "postgresql-8.3-postgis"
      }
    }

    default: {
      fail "postgis version not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }
}
