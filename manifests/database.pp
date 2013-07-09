# ==Definition: postgis::database
#
# Create a new PostgreSQL PostGIS database
#
define postgis::database(
  $owner=false,
  $encoding=false,
  $source=false,
  $overwrite=false) {

  postgresql::database{$name:
    owner     => $owner,
    encoding  => $encoding,
    template  => 'template_postgis',
    source    => $source,
    overwrite => $overwrite,
    require   => Exec['create postgis_template'],
  }

}
