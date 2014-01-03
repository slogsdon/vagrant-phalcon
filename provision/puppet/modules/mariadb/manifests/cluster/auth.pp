class mariadb::cluster::auth (
  $wsrep_sst_password,
  $wsrep_sst_user     = 'root',
) {

  database_user { "${wsrep_sst_user}@%":
    ensure        => present,
    password_hash => mysql_password($wsrep_sst_password),
  }

  database_grant { "${wsrep_sst_user}@%":
    privileges => [ 'all' ],
  }

}

