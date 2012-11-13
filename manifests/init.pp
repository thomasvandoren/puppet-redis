# == Class: redis
#
# Install and configure redis.
#
# === Parameters
#
# [*version*]
#   Version to install.
#   Default: 2.4
#
# [*redis_src_dir*]
#   Location to unpack source code before building and installing it.
#   Default: /opt/redis-src
#
# [*redis_bin_dir*]
#   Location to install redis binaries.
#   Default: /opt/redis
#
# [*redis_max_memory*]
#   Set the redis config value maxmemory (bytes).
#   Default: 4gb
#
# [*redis_max_clients*]
#   Set the redis config value maxclients. If no value provided, it is
#   not included in the configuration for 2.6 and set to 0 (unlimited)
#   for 2.4.
#   Default: 0 (2.4)
#   Default: nil (2.6)
#
# [*redis_timeout*]
#   Set the redis config value timeout (seconds).
#   Default: 300
#
# [*redis_loglevel*]
#   Set the redis config value loglevel. Valid values are debug,
#   verbose, notice, and warning.
#   Default: notice
#
# [*redis_databases*]
#   Set the redis config value databases.
#   Default: 16
#
# [*redis_slowlog_log_slower_than*]
#   Set the redis config value slowlog-log-slower-than (microseconds).
#   Default: 10000
#
# [*redis_showlog_max_len*]
#   Set the redis config value slowlog-max-len.
#   Default: 1024
#
# [*redis_password*]
#   Password used by AUTH command. Will be setted is its not nil.
#   Default: nil
#
# === Examples
#
# include redis
#
# class { 'redis':
#   version          => '2.6',
#   redis_max_memory => '64gb',
# }
#
# === Authors
#
# Thomas Van Doren
#
# === Copyright
#
# Copyright 2012 Thomas Van Doren, unless otherwise noted.
#
class redis (
  $version = '2.4',
  $redis_src_dir = '/opt/redis-src',
  $redis_bin_dir = '/opt/redis',
  $redis_max_memory = '4gb',
  $redis_max_clients = false,
  $redis_timeout = 300,         # 0 = disabled
  $redis_loglevel = 'notice',
  $redis_databases = 16,
  $redis_slowlog_log_slower_than = 10000, # microseconds
  $redis_slowlog_max_len = 1024,
  $redis_password = false,
  ) {
  $real_redis_max_clients = false
  case $version {
    '2.4': {
      $real_version = '2.4.13'
      if ($redis_max_clients == false) {
        $real_redis_max_clients = 0
      }
    }
    '2.6': {
      $real_version = '2.6.4'
    }
    default: {
      fail("Invalid redis version, ${version}. Valid versions are: 2.4 and 2.6.")
    }
  }
  $redis_pkg_name = "redis-${real_version}.tar.gz"
  $redis_pkg = "${redis_src_dir}/${redis_pkg_name}"

  File {
    owner => root,
    group => root,
  }
  file { $redis_src_dir:
    ensure => directory,
  }
  file { '/etc/redis':
    ensure => directory,
  }
  file { 'redis-lib':
    ensure => directory,
    path   => '/var/lib/redis',
  }
  file { 'redis-lib-port':
    ensure => directory,
    path   => '/var/lib/redis/6379',
  }
  file { 'redis-pkg':
    ensure => present,
    path   => $redis_pkg,
    mode   => '0644',
    source => "puppet:///modules/redis/${redis_pkg_name}",
  }
  file { 'redis-init':
    ensure  => present,
    path    => '/etc/init.d/redis_6379',
    mode    => '0755',
    content => template('redis/redis.init.erb')
  }
  file { '6379.conf':
    ensure  => present,
    path    => '/etc/redis/6379.conf',
    mode    => '0644',
    content => template('redis/6379.conf.erb'),
  }
  file { 'redis.conf':
    ensure => present,
    path   => '/etc/redis/redis.conf',
    mode   => '0644',
    source => 'puppet:///modules/redis/redis.conf',
  }
  file { 'redis-cli-link':
    ensure => link,
    path   => '/usr/local/bin/redis-cli',
    target => "${redis_bin_dir}/bin/redis-cli",
  }
  package { 'build-essential':
    ensure => present,
  }
  exec { 'unpack-redis':
    command => "tar --strip-components 1 -xzf ${redis_pkg}",
    cwd     => $redis_src_dir,
    path    => '/bin:/usr/bin',
    unless  => "test -f ${redis_src_dir}/Makefile",
    require => File['redis-pkg'],
  }
  exec { 'install-redis':
    command => "make && make install PREFIX=${redis_bin_dir}",
    cwd     => $redis_src_dir,
    path    => '/bin:/usr/bin',
    unless  => "test $(${redis_bin_dir}/bin/redis-server --version | cut -d ' ' -f 1) = 'Redis'",
    require => [ Exec['unpack-redis'], Package['build-essential'] ],
  }
  service { 'redis':
    ensure    => running,
    name      => 'redis_6379',
    enable    => true,
    require   => [ File['6379.conf'], File['redis.conf'], File['redis-init'], File['redis-lib-port'], Exec['install-redis'] ],
    subscribe => File['6379.conf'],
  }
}
