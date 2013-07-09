# ==Definition: postgis::database
#
# Create a new PostgreSQL PostGIS database
#
define postgis::database(
  $owner=false,
  $encoding=false,
) {

  postgresql::database{$name:
    owner     => $owner,
    encoding  => $encoding,
    template  => 'template_postgis',
    require   => Exec['create postgis_template'],
  }

}
