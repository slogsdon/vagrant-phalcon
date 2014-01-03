# Class: mariadb::config
#
# Parameters:
#
#   [*root_password*]     - root user password.
#   [*old_root_password*] - previous root user password,
#   [*bind_address*]      - address to bind service.
#   [*port*]              - port to bind service.
#   [*etc_root_password*] - whether to save /etc/my.cnf.
#   [*service_name*]      - mariadb service name.
#   [*config_file*]       - my.cnf configuration file path.
#   [*socket*]            - mariadb socket.
#   [*datadir*]           - path to datadir.
#   [*ssl]                - enable ssl
#   [*ssl_ca]             - path to ssl-ca
#   [*ssl_cert]           - path to ssl-cert
#   [*ssl_key]            - path to ssl-key
#   [*log_error]          - path to mariadb error log
#   [*default_engine]     - configure a default table engine
#   [*root_group]         - use specified group for root-owned files
#   [*restart]            - whether to restart mariadbd (true/false)
#
# Actions:
#
# Requires:
#
#   class mariadb::server
#
# Usage:
#
#   class { 'mariadb::config':
#     root_password => 'changeme',
#     bind_address  => $::ipaddress,
#   }
#
class mariadb::config(
  $root_password     = 'UNSET',
  $old_root_password = '',
  $bind_address      = $mariadb::params::bind_address,
  $port              = $mariadb::params::port,
  $etc_root_password = $mariadb::params::etc_root_password,
  $service_name      = $mariadb::params::service_name,
  $config_file       = $mariadb::params::config_file,
  $socket            = $mariadb::params::socket,
  $pidfile           = $mariadb::params::pidfile,
  $datadir           = $mariadb::params::datadir,
  $ssl               = $mariadb::params::ssl,
  $ssl_ca            = $mariadb::params::ssl_ca,
  $ssl_cert          = $mariadb::params::ssl_cert,
  $ssl_key           = $mariadb::params::ssl_key,
  $log_error         = $mariadb::params::log_error,
  $default_engine    = 'UNSET',
  $root_group        = $mariadb::params::root_group,
  $restart           = $mariadb::params::restart,
  $purge_conf_dir    = false
) inherits mariadb::params {

  File {
    owner  => 'root',
    group  => $root_group,
    mode   => '0400',
    notify    => $restart ? {
      true => Exec['mariadb-restart'],
      false => undef,
    },
  }

  if $ssl and $ssl_ca == undef {
    fail('The ssl_ca parameter is required when ssl is true')
  }

  if $ssl and $ssl_cert == undef {
    fail('The ssl_cert parameter is required when ssl is true')
  }

  if $ssl and $ssl_key == undef {
    fail('The ssl_key parameter is required when ssl is true')
  }

  # Using rsync with a MariaDB Galera cluster means that sometimes the DB
  # won't start up properly because rsync is still running. We kill it here
  # before starting the service to give us a better chance.
  exec { 'mariadb-restart':
    command     => "service ${service_name} restart",
    logoutput   => on_failure,
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
    refreshonly => true,
  }

  # manage root password if it is set
  if $root_password != 'UNSET' {
    case $old_root_password {
      '':      { $old_pw='' }
      default: { $old_pw="-p'${old_root_password}'" }
    }

    exec { 'set_mariadb_rootpw':
      command   => "mysqladmin -u root ${old_pw} password '${root_password}'",
      logoutput => true,
      unless    => "mysqladmin -u root -p'${root_password}' status > /dev/null",
      path      => '/usr/local/sbin:/usr/bin:/usr/local/bin',
      notify    => $restart ? {
        true => Exec['mariadb-restart'],
        false => undef,
      },
      require   => File['/etc/mysql/conf.d'],
    }

    file { '/root/.my.cnf':
      content => template('mariadb/my.cnf.pass.erb'),
      require => Exec['set_mariadb_rootpw'],
    }

    if $etc_root_password {
      file{ '/etc/my.cnf':
        content => template('mariadb/my.cnf.pass.erb'),
        require => Exec['set_mariadb_rootpw'],
      }
    }
  } else {
    file { '/root/.my.cnf':
      ensure  => present,
    }
  }

  file { '/etc/mysql':
    ensure => directory,
    mode   => '0755',
  }
  file { '/etc/mysql/conf.d':
    ensure  => directory,
    mode    => '0755',
    recurse => $purge_conf_dir,
    purge   => $purge_conf_dir,
  }
  file { $config_file:
    content => template('mariadb/my.cnf.erb'),
    mode    => '0644',
  }

}
