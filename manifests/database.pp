# ==Definition: postgis::database
#
# Create a new PostgreSQL PostGIS database
#
define postgis::database(
  $owner   = false,
  $charset = false,
) {

  postgresql::database{$name:
    owner    => $owner,
    charset  => $charset,
    template => 'template_postgis',
    require  => Exec['create postgis_template'],
  }

}
