/*

==Class: postgis::ubuntu::base

This class is dedicated to the common parts 
shared by the different flavors of Debian

Requires:
  - Module camptocamp/puppet-postgresql

*/
class postgis::ubuntu::base inherits postgis::base {

  file {"/usr/local/bin/make-postgresql-postgis-template.sh":
    ensure => present,
    owner => root,
    group => root,
    mode => 755,
    source => "puppet:///postgis/usr/local/bin/make-postgresql-postgis-template.sh",
  }

  exec {"create postgis_template":
    command => "/usr/local/bin/make-postgresql-postgis-template.sh",
    unless => "psql -l |grep template_postgis",
    user => postgres,
    require => [ 
      Package["postgis"],
      File["/usr/local/bin/make-postgresql-postgis-template.sh"]
    ]
  }
  
}

