#
# ==Class: postgis::debian::v9-1
#
# Requires:
#  - Class["apt::preferences"]
#
class postgis::debian::v9-1 inherits postgis::debian::base {

  case $::lsbdistcodename {
    squeeze : {
      Package["postgresql-postgis"] {
        name => "postgresql-9.1-postgis"
      }
    }

    default: {
      fail "${name} not available for ${::operatingsystem}/${::lsbdistcodename}"
    }
  }
}
