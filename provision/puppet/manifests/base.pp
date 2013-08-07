Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class { 'apt': always_apt_update => true }

class system::update {
  $packages = [ "build-essential" ]
  package { $packages:
    ensure  => present,
    require => Class['apt::update'],
  }
}

class git::install {
  $packages = [ "git" ]
  package { $packages:
    ensure  => latest,
    require => Class['apt::update'],
  }
}

class php::install {
  apt::ppa { "ppa:ondrej/php5": }
  apt::key { "ondrej": key => "E5267A6C" }

  $packages = [ "php5-fpm", "php5-cli", "php5-dev", "php5-gd", "php5-curl", "php-apc", "php5-mcrypt", "php5-sqlite", "php5-mysql", "php5-memcached", "php5-intl",  "php5-tidy", "php5-imap", "php5-xdebug"]
  package { $packages:
    ensure  => latest,
    require => Class['apt::update'],
  }
}

exec { 'apt-get update':
  command => "/usr/bin/apt-get update -y",
  onlyif  => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
}

include system::update
include git::install
include php::install

include nginx
include nginx::fcgi

nginx::fcgi::site {"default":
  root            => "/vagrant/src/Public",
  fastcgi_pass    => "unix:/var/run/php5-fpm.sock",
  server_name     => ["localhost", "$hostname", "$fqdn"],
}

class { 'mysql::server':
  config_hash => { 'root_password' => 'secure_root_password' }
}

mysql::db { 'dbname':
  user     => 'dbuser',
  password => 'dbpass',
  host     => 'localhost',
  grant    => ['all'],
}