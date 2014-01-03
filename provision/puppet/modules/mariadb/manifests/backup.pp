# Class: mariadb::backup
#
# This module handles ...
#
# Parameters:
#   [*backupuser*]     - The name of the mariadb backup user.
#   [*backuppassword*] - The password of the mariadb backup user.
#   [*backupdir*]      - The target directory of the mariadbdump.
#   [*backupcompress*] - Boolean to compress backup with bzip2.
#
# Actions:
#   GRANT SELECT, RELOAD, LOCK TABLES ON *.* TO 'user'@'localhost'
#    IDENTIFIED BY 'password';
#
# Requires:
#   Class['mariadb::config']
#
# Sample Usage:
#   class { 'mariadb::backup':
#     backupuser     => 'myuser',
#     backuppassword => 'mypassword',
#     backupdir      => '/tmp/backups',
#     backupcompress => true,
#   }
#
class mariadb::backup (
  $backupuser,
  $backuppassword,
  $backupdir,
  $backupcompress = true,
  $ensure = 'present'
) {

  database_user { "${backupuser}@localhost":
    ensure        => $ensure,
    password_hash => mysql_password($backuppassword),
  }

  database_grant { "${backupuser}@localhost":
    privileges => [ 'Select_priv', 'Reload_priv', 'Lock_tables_priv', 'Show_view_priv' ],
    require    => Database_user["${backupuser}@localhost"],
  }

  cron { 'mysql-backup':
    ensure  => $ensure,
    command => '/usr/local/sbin/mysqlbackup.sh',
    user    => 'root',
    hour    => 23,
    minute  => 5,
    require => File['mysqlbackup.sh'],
  }

  file { 'mysqlbackup.sh':
    ensure  => $ensure,
    path    => '/usr/local/sbin/mysqlbackup.sh',
    mode    => '0700',
    owner   => 'root',
    group   => 'root',
    content => template('mariadb/mysqlbackup.sh.erb'),
  }

  file { 'mysqlbackupdir':
    ensure => 'directory',
    path   => $backupdir,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }
}
