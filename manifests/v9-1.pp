class postgis::v9-1 {
  case $::operatingsystem {
    Debian: {
      case $::lsbdistcodename {
        squeeze : { include postgis::debian::v9-1 }
        default : { fail "${name} not available for ${::operatingsystem}/${::lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${::operatingsystem}" }
  }
}
