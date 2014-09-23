# Class: postgis
class postgis(
  $version       = undef,
  $check_version = undef,
) {

  if $version != undef {
    warning('Passing "version" to postgis is deprecated.')
  }
  if $check_version != undef {
    warning('Passing "check_version" to postgis in deprecated.')
  }

  $script_path = $::osfamily ? {
    Debian => $::postgresql::globals::version ? {
      '8.3'   => '/usr/share/postgresql-8.3-postgis',
      default => "/usr/share/postgresql/${::postgresql::globals::globals_version}/contrib/postgis-${::postgresql::globals::globals_postgis_version}",
    },
    RedHat => "/usr/pgsql-${::postgresql::globals::globals_version}/share/contrib/postgis-${::postgresql::globals::globals_postgis_version}",
  }

  class { 'postgresql::server::postgis': }
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

  if $::postgresql::globals::globals_version >= '9.1' {
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
