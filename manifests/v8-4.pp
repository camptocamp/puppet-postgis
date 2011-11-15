class postgis::v8-4 {
  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        lenny,squeeze :  { include postgis::debian::v8-4 }
        default:         { fail "postgis 8.4 not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    Ubuntu: {
      case $lsbdistcodename {
        lucid : { include postgis::ubuntu::v8-4 }
        default: { fail "postgis 8.4 not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}
