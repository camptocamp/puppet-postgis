class postgis::v8-3 {
  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        etch,lenny :  { include postgis::debian::v8-3 }
        default: { fail "postgis 8.3 not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}
