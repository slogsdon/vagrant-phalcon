class mariadb::cluster::status (
  $status_user,
  $status_password,
) {

  file { '/usr/local/bin/clustercheck':
    content => template('mariadb/clustercheck.erb'),
    mode    => '0755',
  }

  file { '/usr/local/bin/clustercheck-maintenance':
    source => 'puppet:///modules/mariadb/clustercheck-maintenance.sh',
    mode   => '0755',
  }

  augeas { 'mysqlchk':
    context => '/files/etc/services',
    changes => [
      "set /files/etc/services/service-name[port = '9200']/port 9200",
      "set /files/etc/services/service-name[port = '9200'] mysqlchk",
      "set /files/etc/services/service-name[port = '9200']/protocol tcp",
    ],
  }

  xinetd::server { 'mysqlchk':
    id     => 'mysqlchk',
    server => '/usr/local/bin/clustercheck',
    port   => '9200',
    user   => 'nobody',
    flags  => 'REUSE',
  }

  database_user { "${status_user}@localhost":
    ensure        => present,
    password_hash => mysql_password($status_password),
  }

  database_grant { "${status_user}@localhost":
    privileges => [ 'process_priv' ],
  }

}

