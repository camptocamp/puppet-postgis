require 'spec_helper'

describe 'postgis' do

  context 'on Debian wheezy with old postgis version' do

    let :pre_condition do
      "class {'::postgresql::globals': encoding => 'UTF8', version => '9.1', postgis_version => '1.5'} -> class {'::postgresql::server':}"
    end

    let(:facts) {{
      :concat_basedir         => '/var/lib/puppet/concat',
      :id                     => 'root',
      :lsbdistcodename        => 'wheezy',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => 'wheezy',
      :osfamily               => 'Debian',
      :path                   => '/foo',
    }}

    context 'with no parameter' do

      it { should contain_class('postgresql::server::postgis') }
  
      it do
        should contain_postgresql__server__database('template_postgis').with({
          :istemplate => true,
          :template   => 'template1',
        })
      end
  
      it do
        should contain_exec('createlang plpgsql template_postgis').with({
          :user   => 'postgres',
          :unless => 'createlang -l template_postgis | grep -q plpgsql',
        }).that_requires('Postgresql::Server::Database[template_postgis]')
      end
  
      it do
        should contain_exec('psql -q -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql').with({
          :user   => 'postgres',
          :unless => 'echo "\dt" | psql -d template_postgis | grep -q geometry_columns',
        })
      end
  
      it do
        should contain_exec('psql -q -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql').with({
          :user   => 'postgres',
          :unless => 'test $(psql -At -d template_postgis -c "select count(*) from spatial_ref_sys") -ne 0',
        })
      end

    end
  end

  context 'on Debian wheezy with new postgis version' do

    let :pre_condition do
      "class {'::postgresql::globals': encoding => 'UTF8', version => '9.1', postgis_version => '2.1'} -> class {'::postgresql::server':}"
    end

    let(:facts) {{
      :concat_basedir         => '/var/lib/puppet/concat',
      :id                     => 'root',
      :lsbdistcodename        => 'wheezy',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => 'wheezy',
      :osfamily               => 'Debian',
      :path                   => '/foo',
    }}

    context 'with no parameter' do

      it { should contain_class('postgresql::server::postgis') }
  
      it do
        should contain_postgresql__server__database('template_postgis').with({
          :istemplate => true,
          :template   => 'template1',
        })
      end
  
      it do
        should contain_postgresql_psql('Add postgis extension on template_postgis').with({
          :db      => 'template_postgis',
          :command => 'CREATE EXTENSION postgis',
          :unless  => "SELECT extname FROM pg_extension WHERE extname = 'postgis'",
        }).that_requires('Postgresql::Server::Database[template_postgis]')
      end

      it do
        should contain_postgresql_psql('Add postgis_topology extension on template_postgis').with({
          :db      => 'template_postgis',
          :command => 'CREATE EXTENSION postgis_topology',
          :unless  => "SELECT extname FROM pg_extension WHERE extname = 'postgis_topology'",
        })
      end

    end
  end

end
