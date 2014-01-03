class mariadb::cluster::config (
  $wsrep_cluster_name,
  $wsrep_sst_auth,
  $wsrep_sst_method,
  $wsrep_slave_threads,
) {

  file { '/etc/mysql/conf.d/galera_replication.cnf':
    content => template('mariadb/galera_replication.cnf.erb'),
  }

}
