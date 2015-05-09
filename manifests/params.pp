# == Class: redis::params
#
# Redis params.
#
# === Parameters
#
# === Authors
#
# Thomas Van Doren
#
# === Copyright
#
# Copyright 2012 Thomas Van Doren, unless otherwise noted.
#
class redis::params {

  $redis_port = '6379'
  $redis_bind_address = false
  $version = '2.8.12'
  $redis_src_dir = '/opt/redis-src'
  $redis_bin_dir = '/opt/redis'
  $redis_max_memory = '4gb'
  $redis_max_clients = false
  $redis_timeout = 300         # 0 = disabled
  $redis_loglevel = 'notice'
  $redis_databases = 16
  $redis_slowlog_log_slower_than = 10000 # microseconds
  $redis_slowlog_max_len = 1024
  $redis_password = false
  $redis_saves = ['save 900 1', 'save 300 10', 'save 60 10000']
  $redis_user = 'root'
  $redis_group = 'root'
  $redis_appendonly = false
  $redis_appendfilename = 'appendonly.aof'
  $redis_appendfsync = 'everysec'
  $redis_no_appendfsync_on_rewrite = false
  $redis_auto_aof_rewrite_percentage = 100
  $redis_auto_aof_rewrite_min_size = '64mb'
  $redis_aof_load_truncated = true
  $redis_aof_rewrite_incremental_fsync = true
  $redis_cluster_enabled = false
  $redis_cluster_config_file = 'nodes-6379.conf'
  $redis_cluster_node_timeout = 15000
  $redis_cluster_slave_validity_factor = 10
  $redis_cluster_migration_barrier = 1
  $redis_cluster_require_full_coverage = true
  $redis_max_memory_policy = 'noeviction'

}
