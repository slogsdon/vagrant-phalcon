class mariadb::server::monitor (
  $mariadb_monitor_username,
  $mariadb_monitor_password,
  $mariadb_monitor_hostname
) {

  Class['mariadb::server'] -> Class['mariadb::server::monitor']

  database_user{ "${mariadb_monitor_username}@${mariadb_monitor_hostname}":
    ensure        => present,
    password_hash => mysql_password($mariadb_monitor_password),
  }

  database_grant { "${mariadb_monitor_username}@${mariadb_monitor_hostname}":
    privileges => [ 'process_priv', 'super_priv' ],
    require    => Database_user["${mariadb_monitor_username}@${mariadb_monitor_hostname}"],
  }

}
