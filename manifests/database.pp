# ==Definition: postgis::database
#
# Create a new PostgreSQL PostGIS database
#
define postgis::database(
  $owner   = false,
  $charset = false,
) {

  postgresql::server::database{$name:
    owner    => $owner,
    encoding => $charset,
    template => 'template_postgis',
    require  => Exec['create postgis_template'],
  }

}
