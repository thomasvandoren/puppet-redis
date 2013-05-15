#
# Smoke test.
#
class { 'redis':
  redis_version => '2.6.13',
}

redis::instance { 'default': }

redis::instance { '6380':
  redis_port    => '6380',
}
