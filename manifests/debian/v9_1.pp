#
# ==Class: postgis::debian::v9_1
#
# Requires:
#  - Class['apt::preferences']
#
class postgis::debian::v9_1 inherits postgis::debian::base {

  case $::lsbdistcodename {
    /squeeze|wheezy/ : {
      Package['postgresql-postgis'] {
        name => 'postgresql-9.1-postgis'
      }
    }

    default: {
      fail "${name} not available for ${::operatingsystem}/${::lsbdistcodename}"
    }
  }
}
