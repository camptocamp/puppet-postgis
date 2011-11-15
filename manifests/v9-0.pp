class postgis::v9-0 {
  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        squeeze : { include postgis::debian::v9-0 }
        default : { fail "${name} not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}
