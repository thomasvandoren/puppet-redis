require 'spec_helper'

describe 'redis', :type => 'class' do

  context "On a Debian OS with default params" do

    let :facts do
      {
        :osfamily  => 'Debian',
        :ipaddress => '10.0.0.1'
      }
    end

    it do

      should contain_package('build-essential').with_ensure('present')

      # add redis_src_dir file
      should contain_file('/opt/redis-src').with(:ensure => 'directory')
      should contain_file('/etc/redis').with(:ensure => 'directory')
      should contain_file('redis-lib').with(:ensure => 'directory',
                                            :path   => '/var/lib/redis')
      should contain_file('redis-lib-port').with(:ensure => 'directory',
                                                 :path   => '/var/lib/redis/6379')
      should contain_file('redis-pkg').with(:ensure => 'present',
                                            :path   => '/opt/redis-src/redis-2.4.13.tar.gz',
                                            :mode   => '0644',
                                            :source => 'puppet:///modules/redis/redis-2.4.13.tar.gz')
      should contain_file('redis-init').with(:ensure => 'present',
                                             :path   => '/etc/init.d/redis_6379',
                                             :mode   => '0755')
      should contain_file('redis-cli-link').with(:ensure => 'link',
                                                 :path   => '/usr/local/bin/redis-cli',
                                                 :target => '/opt/redis/bin/redis-cli')

      should contain_exec('unpack-redis').with(:cwd  => '/opt/redis-src',
                                               :path => '/bin:/usr/bin')
      should contain_exec('install-redis').with(:cwd   => '/opt/redis-src',
                                                :path  => '/bin:/usr/bin')

      should contain_service('redis').with(:ensure => 'running',
                                           :name   => 'redis_6379',
                                           :enable => true)

    end

  end

end
