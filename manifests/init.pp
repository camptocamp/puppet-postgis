# Class: postgis
#
# Install postgis using debian packages
#
# Parameters:
#   ['version']    - Version of the postgresql install to use
#   ['check_version'] - Whether to check the version specified using the
#                       `version` parameter. Set this to `false` if you
#                       are using your own backported version for example.
#
# Sample usage:
#   include postgis
#
class postgis (
  $version = $postgis::params::default_version,
  $check_version = true,
) inherits postgis::params {

  # Define variables
  case $::osfamily {
    'RedHat': {
       $ostype = 'redhat'
    }
    'Debian': {
       $ostype = 'debian'
    }
    default: { fail "Unsupported OS family ${::osfamily}" }
  }

  if ($check_version) {
    case $::osfamily {
      'Debian' : {
        case $::lsbdistcodename {
          'lenny': {
            validate_re($version, '^(8\.[34])$', "version ${version} is not supported for ${::operatingsystem} ${::lsbdistcodename}!")
          }
          'squeeze': {
            validate_re($version, '^(8\.4|9\.0|9\.1)$', "version ${version} is not supported for ${::operatingsystem} ${::lsbdistcodename}!")
          }
          'wheezy': {
            validate_re($version, '^9\.1$', "version ${version} is not supported for ${::operatingsystem} ${::lsbdistcodename}!")
          }
          'lucid': {
            validate_re($version, '^8\.4$', "version ${version} is not supported for ${::operatingsystem} ${::lsbdistcodename}!")
          }
          /^(precise|quantal)$/: {
            validate_re($version, '^9\.1$', "version ${version} is not supported for ${::operatingsystem} ${::lsbdistcodename}!")
          }
          default: { fail "${::operatingsystem} ${::lsbdistcodename} is not yet supported!" }
        }
      }
      'RedHat' : {
        case $::lsbmajdistrelease {
          '6': {
            validate_re($version, '^8\.4$', "version ${version} is not supported for ${::operatingsystem} ${::lsbdistcodename}!")
          }
          default: { fail "${::operatingsystem} ${::lsbdistrelease} is not yet supported!" }
        }
      }
      default: { fail "${::operatingsystem} is not yet supported!" }
    }
  }

  # Include base
  include "postgis::${ostype}"
}
