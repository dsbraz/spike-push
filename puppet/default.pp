exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
}

package { ['build-essential', 'bison', 'openssl', 'libreadline5', 'curl',
           'git-core', 'zlib1g', 'zlib1g-dev', 'libopenssl-ruby',
           'libcurl4-openssl-dev', 'libssl-dev', 'libsqlite3-0',
           'libxslt1-dev', 'autoconf', 'libgdbm-dev', 'libncurses5-dev',
           'automake', 'libtool', 'libffi-dev', 'libsqlite3-dev', 'sqlite3',
           'libxml2-dev', 'libyaml-dev', 'nodejs', 'redis-server', 'vim']:
  ensure => installed,
  require => Exec['apt-get update'],
}

service { 'redis-server':
  ensure => running,
  require => Package['redis-server'],
}
