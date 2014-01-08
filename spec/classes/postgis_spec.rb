require 'spec_helper'

describe 'postgis' do

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  context 'on Debian wheezy' do

    let(:facts) {{
      :concat_basedir           => '/var/lib/puppet/concat',
      :lsbdistcodename          => 'wheezy',
      :operatingsystem          => 'Debian',
      :operatingsystemrelease   => 'wheezy',
      :osfamily                 => 'Debian',
    }}
  
    context 'with no parameter' do
  
      it { should contain_class('postgis') }
  
      it { should contain_package('postgresql-9.1-postgis')
        .with({
          :ensure => :present,
        })
        .that_requires('Class[postgresql::server]')
      }
  
      it { should contain_postgresql__server__database('template_postgis')
        .with({
          :istemplate => true,
          :template   => 'template1',
        })
        .that_requires('Package[postgresql-9.1-postgis]')
      }
  
      it { should contain_exec('createlang plpgsql template_postgis')
        .with({
          :user   => 'postgres',
          :unless => 'createlang -l template_postgis | grep -q plpgsql',
        })
        .that_requires('Postgresql::Server::Database[template_postgis]')
      }
  
      it { should contain_exec('psql -q -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql')
        .with({
          :user   => 'postgres',
          :unless => 'echo "\dt" | psql -d template_postgis | grep -q geometry_columns',
        })
        .that_requires('Exec[createlang plpgsql template_postgis]')
      }
  
      it { should contain_exec('psql -q -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql')
        .with({
          :user   => 'postgres',
          :unless => 'test $(psql -At -d template_postgis -c "select count(*) from spatial_ref_sys") -ne 0',
        })
        .that_requires('Exec[createlang plpgsql template_postgis]')
      }
  
      it { should contain_postgresql__server__table_grant('GRANT ALL ON geometry_columns TO public')
        .with({
          :privilege => 'ALL',
          :table     => 'geometry_columns',
          :db        => 'template_postgis',
          :role      => 'public',
        })
        .that_requires('Exec[psql -q -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql]')
        .that_notifies('Postgresql_psql[vacuum postgis]')
      }
  
      it { should contain_postgresql__server__table_grant('GRANT SELECT ON spatial_ref_sys TO public')
        .with({
          :privilege => 'SELECT',
          :table     => 'spatial_ref_sys',
          :db        => 'template_postgis',
          :role      => 'public',
        })
        .that_requires('Exec[psql -q -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql]')
        .that_notifies('Postgresql_psql[vacuum postgis]')
      }
  
      it { should contain_postgresql_psql('vacuum postgis')
        .with({
          :command     => 'VACUUM FREEZE',
          :db          => 'template_postgis',
          :refreshonly => true,
        })
      }
    end
  end

end
