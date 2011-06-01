import "classes/*.pp"
import "definitions/*.pp"

class postgis {
  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        etch,lenny :  { include postgis::debian::v8-3 }
        squeeze    :  { include postgis::debian::v8-4 }
        default: { fail "postgis not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    Ubuntu: {
      case $lsbdistcodename {
        lucid : { include postgis::ubuntu::v8-4 }
        default: { fail "postgis not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}

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

