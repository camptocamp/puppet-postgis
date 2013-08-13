class postgis::debian {

  include postgis::client
  include ::postgresql::server

  file {'/usr/local/bin/make-postgresql-postgis-template.sh':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/postgis/usr/local/bin/make-postgresql-postgis-template.sh',
  }

  exec {'create postgis_template':
    command => '/usr/local/bin/make-postgresql-postgis-template.sh',
    unless  => 'psql -l |grep template_postgis',
    user    => postgres,
    require => [
      Package["postgresql-${postgis::version}-postgis"],
      Service['postgresqld'],
      File['/usr/local/bin/make-postgresql-postgis-template.sh'],
    ]
  }

  package {"postgresql-${postgis::version}-postgis":
    ensure  => present,
    require => Class['postgresql::server'],
  }

}
