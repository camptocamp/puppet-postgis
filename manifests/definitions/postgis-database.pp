/*

==Definition: postgis::database

Create a new PostgreSQL PostGIS database

*/
define postgis::database(
  $ensure=present, 
  $owner=false, 
  $encoding=false,
  $source=false, 
  $overwrite=false) {

  postgresql::database{$name:
    ensure => $ensure,
    owner => $owner,
    encoding => $encoding,
    template => "template_postgis",
    source => $source,
    overwrite => $overwrite,
  }

}
