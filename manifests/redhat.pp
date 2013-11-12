class postgis::redhat {

  if $::postgis::version != '9.1' {
    fail "Postgis ${::postgis::version} not supported yet on ${::operatingsystem}!"
  }

  Class['postgresql::server']
  ->
  package { [ 'postgis91', 'postgis91-utils' ]:
    ensure => 'present',
  }
  ->
  postgresql::server::database { 'template_postgis':
    istemplate => true,
  }
  ->
  exec { 'createlang plpgsql template_postgis':
    user    => 'postgres',
    unless  => 'createlang -l template_postgis | grep -q plpgsql',
    require => Postgresql::Server::Database['template_postgis'],
  }

  # Table geometry_columns
  exec { "psql -q -d template_postgis -f ${::postgis::script_path}/postgis.sql":
    user    => 'postgres',
    unless  => 'echo "\dt" | psql -d template_postgis | grep -q geometry_columns',
    require => Exec['createlang plpgsql template_postgis'],
  }
  ->
  postgresql::server::table_grant { 'GRANT ALL ON geometry_columns TO public':
    privilege => 'ALL',
    table     => 'geometry_columns',
    db        => 'template_postgis',
    role      => 'public',
    notify    => Postgresql_psql['vacuum postgis'],
  }

  # Table spatial_ref_sys
  exec { "psql -q -d template_postgis -f ${::postgis::script_path}/spatial_ref_sys.sql":
    user    => 'postgres',
    unless  => 'echo "\dt" | psql -d template_postgis | grep -q spatial_ref_sys',
    require => Exec['createlang plpgsql template_postgis'],
  }
  ->
  postgresql::server::table_grant { 'GRANT SELECT ON spatial_ref_sys TO public':
    privilege => 'SELECT',
    table     => 'spatial_ref_sys',
    db        => 'template_postgis',
    role      => 'public',
    notify    => Postgresql_psql['vacuum postgis'],
  }

  postgresql_psql { 'vacuum postgis':
    command     => 'VACUUM FREEZE',
    db          => 'template_postgis',
    refreshonly => true,
  }

}
