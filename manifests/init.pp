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
  $version       = $::postgresql::globals::default_version,
  $check_version = true,
) {

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

  $script_path = $::osfamily ? {
    Debian => $version ? {
      '8.3'           => '/usr/share/postgresql-8.3-postgis',
      /(8.4|9.0|9.1)/ => "/usr/share/postgresql/${version}/contrib/postgis-1.5",
    },
    RedHat => $version ? {
      '9.1' => '/usr/pgsql-9.1/share/contrib/postgis-1.5',
    },
  }

  $packages = $::osfamily ? {
    Debian => ["postgresql-${version}-postgis", 'postgis'],
    RedHat => ['postgis91', 'postgis91-utils'],
  }

  Class['postgresql::server']
  ->
  package { $packages:
    ensure => 'present',
  }
  ->
  postgresql::server::database { 'template_postgis':
    istemplate => true,
    template   => 'template1',
  }
  ->
  exec { 'createlang plpgsql template_postgis':
    user    => 'postgres',
    unless  => 'createlang -l template_postgis | grep -q plpgsql',
  }

  exec { "psql -q -d template_postgis -f ${script_path}/postgis.sql":
    user    => 'postgres',
    unless  => 'echo "\dt" | psql -d template_postgis | grep -q geometry_columns',
    require => Exec['createlang plpgsql template_postgis'],
  }

  exec { "psql -q -d template_postgis -f ${script_path}/spatial_ref_sys.sql":
    user    => 'postgres',
    unless  => 'test $(psql -At -d template_postgis -c "select count(*) from spatial_ref_sys") -ne 0',
    require => Exec['createlang plpgsql template_postgis'],
  }

  if $version >= '9.1' {
    postgresql::server::table_grant { 'GRANT ALL ON geometry_columns TO public':
      privilege => 'ALL',
      table     => 'geometry_columns',
      db        => 'template_postgis',
      role      => 'public',
      require   => Exec["psql -q -d template_postgis -f ${script_path}/postgis.sql"],
      notify    => Postgresql_psql['vacuum postgis'],
    }
    postgresql::server::table_grant { 'GRANT SELECT ON spatial_ref_sys TO public':
      privilege => 'SELECT',
      table     => 'spatial_ref_sys',
      db        => 'template_postgis',
      role      => 'public',
      require   => Exec["psql -q -d template_postgis -f ${script_path}/spatial_ref_sys.sql"],
      notify    => Postgresql_psql['vacuum postgis'],
    }
  } else {
    # SELECT 1 WHERE has_table_privilege('public',...) does not work before 9.1
    exec { 'echo GRANT ALL ON geometry_columns TO public | psql -q':
      refreshonly => true,
      subscribe   => Exec["psql -q -d template_postgis -f ${script_path}/postgis.sql"],
    }
    exec { 'echo GRANT SELECT ON spatial_ref_sys TO public | psql -q':
      refreshonly => true,
      subscribe   => Exec["psql -q -d template_postgis -f ${script_path}/spatial_ref_sys.sql"],
    }
  }

  postgresql_psql { 'vacuum postgis':
    command     => 'VACUUM FREEZE',
    db          => 'template_postgis',
    refreshonly => true,
  }

}
