require 'spec_helper'

describe 'postgis' do
  let :pre_condition do
    "class {'postgresql::server':}"
  end
  let(:facts) {{
    :concat_basedir           => '/var/lib/puppet/concat',
    :lsbdistcodename          => 'wheezy',
    :operatingsystem          => 'Debian',
    :operatingsystemrelease   => 'wheezy',
    :osfamily                 => 'Debian',
    :postgres_default_version => '9.1',
  }}
  it { should contain_class('postgis') }
end
