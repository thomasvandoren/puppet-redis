# == Class: redis
#
# Install redis.
#
# === Parameters
#
# [*version*]
#   Version to install.
#   Default: 2.8.12
#
# [*redis_src_dir*]
#   Location to unpack source code before building and installing it.
#   Default: /opt/redis-src
#
# [*redis_bin_dir*]
#   Location to install redis binaries.
#   Default: /opt/redis
#
# [*redis_port*]
#   Accept redis connections on this port.
#   Default: 6379
#
# [*redis_bind_address*]
#   Address to bind to.
#   Default: false, which binds to all interfaces
#
# [*redis_max_memory*]
#   Max memory usage configuration.
#   Default: 4gb
#
# [*redis_max_clients*]
#   Set the redis config value maxclients.
#   Default: nil
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
#   Password used by AUTH command. Will be set if it is not nil.
#   Default: nil
#
# [*redis_saves*]
#   Redis snapshotting parameters. Set to false for no snapshots.
#   Default: ['save 900 1', 'save 300 10', 'save 60 10000']
#
# [*redis_appendonly*]
#   Append Only File persistence mode.
#   Default: false
#
# [*redis_appendfilename*]
#   Append Only File name.
#   Default: appendonly.aof
#
# [*redis_appendfsync*]
#   Append Only File fsync mode.
#   Default: everysec
#
# [*redis_no_appendfsync_on_rewrite*]
#   Append Only File prevent fsync during rewrite.
#   Default: false
#
# [*redis_auto_aof_rewrite_percentage*]
#   Append Only File auto-rewrite percentage.
#   Default: 100
#
# [*redis_auto_aof_rewrite_min_size*]
#   Append Only File auto-rewrite size.
#   Default: 64mb
#
# [*redis_aof_load_truncated*]
#   Append Only File load truncated.
#   Default: true (>= 2.8.15)
#
# [*redis_aof_rewrite_incremental_fsync*]
#   Append Only File rewrite incremental fsync.
#   Default: true
#
# [*redis_cluster_enabled*]
#   Cluster enabled.
#   Default: false (>= 3.0.0)
#
# [*redis_cluster_config_file*]
#   Cluster config file for nodes.
#   Default: nodes-6379.conf (>= 3.0.0)
#
# [*redis_cluster_node_timeout*]
#   Cluster node timeout.
#   Default: 15000 (>= 3.0.0)
#
# [*redis_cluster_slave_validity_factor*]
#   Cluster slave validity factor for failover.
#   Default: 10 (>= 3.0.0)
#
# [*redis_cluster_migration_barrier*]
#   Cluster migration barrier for slaves.
#   Default: 1 (>= 3.0.0)
#
# [*redis_cluster_require_full_coverage*]
#   Cluster require full coverage of hash slots.
#   Default: true (>= 3.0.0)
#
# [*redis_max_memory_policy*]
#   Set the redis config value maxmemory-policy.
#   Default: noeviction
#
# === Examples
#
# include redis
#
# class { 'redis':
#   version       => '2.8',
#   redis_src_dir => '/fake/path/redis-src',
#   redis_bin_dir => '/fake/path/redis',
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
  $version = $redis::params::version,
  $redis_src_dir = $redis::params::redis_src_dir,
  $redis_bin_dir = $redis::params::redis_bin_dir,
  $redis_user = $redis::params::redis_user,
  $redis_group = $redis::params::redis_group,
  $redis_port = $redis::params::redis_port,
  $redis_bind_address = $redis::params::redis_bind_address,
  $redis_max_memory = $redis::params::redis_max_memory,
  $redis_max_clients = $redis::params::redis_max_clients,
  $redis_timeout = $redis::params::redis_timeout,
  $redis_loglevel = $redis::params::redis_loglevel,
  $redis_databases = $redis::params::redis_databases,
  $redis_slowlog_log_slower_than = $redis::params::redis_slowlog_log_slower_than,
  $redis_slowlog_max_len = $redis::params::redis_slowlog_max_len,
  $redis_password = $redis::params::redis_password,
  $redis_saves = $redis::params::redis_saves,
  $redis_appendonly = $redis::params::redis_appendonly,
  $redis_appendfilename = $redis::params::redis_appendfilename,
  $redis_appendfsync = $redis::params::redis_appendfsync,
  $redis_no_appendfsync_on_rewrite = $redis::params::redis_no_appendfsync_on_rewrite,
  $redis_auto_aof_rewrite_percentage = $redis::params::redis_auto_aof_rewrite_percentage,
  $redis_auto_aof_rewrite_min_size = $redis::params::redis_auto_aof_rewrite_min_size,
  $redis_aof_load_truncated = $redis::params::redis_aof_load_truncated,
  $redis_aof_rewrite_incremental_fsync = $redis::params::redis_aof_rewrite_incremental_fsync,
  $redis_cluster_enabled = $redis::params::redis_cluster_enabled,
  $redis_cluster_config_file = $redis::params::redis_cluster_config_file,
  $redis_cluster_node_timeout = $redis::params::redis_cluster_node_timeout,
  $redis_cluster_slave_validity_factor = $redis::params::redis_cluster_slave_validity_factor,
  $redis_cluster_migration_barrier = $redis::params::redis_cluster_migration_barrier,
  $redis_cluster_require_full_coverage = $redis::params::redis_cluster_require_full_coverage,
  $redis_max_memory_policy = $redis::params::redis_max_memory_policy
) inherits redis::params {

  include wget
  include gcc

  $redis_pkg_name = "redis-${version}.tar.gz"
  $redis_pkg = "${redis_src_dir}/${redis_pkg_name}"

  # Install default instance
  redis::instance { 'redis-default':
    redis_port                          => $redis_port,
    redis_bind_address                  => $redis_bind_address,
    redis_max_memory                    => $redis_max_memory,
    redis_max_clients                   => $redis_max_clients,
    redis_timeout                       => $redis_timeout,
    redis_loglevel                      => $redis_loglevel,
    redis_databases                     => $redis_databases,
    redis_slowlog_log_slower_than       => $redis_slowlog_log_slower_than,
    redis_slowlog_max_len               => $redis_slowlog_max_len,
    redis_password                      => $redis_password,
    redis_saves                         => $redis_saves,
    redis_appendonly                    => $redis_appendonly,
    redis_appendfilename                => $redis_appendfilename,
    redis_appendfsync                   => $redis_appendfsync,
    redis_no_appendfsync_on_rewrite     => $redis_no_appendfsync_on_rewrite,
    redis_auto_aof_rewrite_percentage   => $redis_auto_aof_rewrite_percentage,
    redis_auto_aof_rewrite_min_size     => $redis_auto_aof_rewrite_min_size,
    redis_aof_load_truncated            => $redis_aof_load_truncated,
    redis_aof_rewrite_incremental_fsync => $redis_aof_rewrite_incremental_fsync,
    redis_cluster_enabled               => $redis_cluster_enabled,
    redis_cluster_config_file           => $redis_cluster_config_file,
    redis_cluster_node_timeout          => $redis_cluster_node_timeout,
    redis_cluster_slave_validity_factor => $redis_cluster_slave_validity_factor,
    redis_cluster_migration_barrier     => $redis_cluster_migration_barrier,
    redis_cluster_require_full_coverage => $redis_cluster_require_full_coverage,
    redis_max_memory_policy             => $redis_max_memory_policy,
  }

  File {
    owner => $redis_user,
    group => $redis_group
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

  exec { 'get-redis-pkg':
    command => "/usr/bin/wget --output-document ${redis_pkg} http://download.redis.io/releases/${redis_pkg_name}",
    unless  => "/usr/bin/test -f ${redis_pkg}",
    require => File[$redis_src_dir],
  }

  file { 'redis-cli-link':
    ensure => link,
    path   => '/usr/local/bin/redis-cli',
    target => "${redis_bin_dir}/bin/redis-cli",
  }
  exec { 'unpack-redis':
    command => "tar --strip-components 1 -xzf ${redis_pkg}",
    cwd     => $redis_src_dir,
    path    => '/bin:/usr/bin',
    unless  => "test -f ${redis_src_dir}/Makefile",
    require => Exec['get-redis-pkg'],
  }
  exec { 'install-redis':
    command => "make && make install PREFIX=${redis_bin_dir}",
    cwd     => $redis_src_dir,
    path    => '/bin:/usr/bin',
    unless  => "test $(${redis_bin_dir}/bin/redis-server --version | cut -d ' ' -f 1) = 'Redis'",
    require => [ Exec['unpack-redis'], Class['gcc'] ],
  }

}
