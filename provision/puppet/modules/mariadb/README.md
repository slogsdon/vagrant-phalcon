# MariaDB Galera cluster module for Puppet

This module manages a MariaDB Galera cluster on Linux (RedHat/Debian) distros. A native mysql provider implements database resource type to handle database, database user, and database permission.

Pluginsync needs to be enabled for this module to function properly.
Read more about pluginsync in our [docs](http://docs.puppetlabs.com/guides/plugins_in_modules.html#enabling-pluginsync)

NOTE: This is basically a copy of the [PuppetLabs MySQL module](https://github.com/puppetlabs/puppetlabs-mysql), modified for use with MariaDB and supporting the galera cluster functions.

This module is based on work by David Schmitt. The following contributor have contributed patches to this module (beyond Puppet Labs):

* Christian G. Warden
* Daniel Black
* Justin Ellison
* Lowe Schmidt
* Matthias Pigulla
* William Van Hevelingen
* Michael Arnold

## Usage

### mariadb
Installs the mariadb-client package.

    class { 'mariadb': }

### mariadb::server
Installs mariadb-server packages, configures my.cnf and starts mariadb service:

    class { 'mariadb::server':
      config_hash => { 'root_password' => 'foo' }
    }

Database login information stored in `/root/.my.cnf`.

## mariadb::cluster
Installs the mariadb and supporting galera packages for a cluster.

    class { 'mariadb::cluster':
        cluster_servers => $mariadb_cluster_servers,
        config_hash     => {
          'root_password' => 'foo',
          'bind_address'  => '0.0.0.0',
          'restart'       => false,     # manually manage service with galera
        }
    }

### mariadb::db
Creates a database with a user and assign some privileges.

    mariadb::db { 'mydb':
      user     => 'myuser',
      password => 'mypass',
      host     => 'localhost',
      grant    => ['all'],
    }

### mariadb::backup
Installs a mysql backup script, cronjob, and priviledged backup user.

    class { 'mariadb::backup':
      backupuser     => 'myuser',
      backuppassword => 'mypassword',
      backupdir      => '/tmp/backups',
    }

### Providers for database types:
MySQL provider supports puppet resources command:

    $ puppet resource database
    database { 'information_schema':
      ensure  => 'present',
      charset => 'utf8',
    }
    database { 'mysql':
      ensure  => 'present',
      charset => 'latin1',
    }

The custom resources can be used in any other manifests:

    database { 'mydb':
      charset => 'latin1',
    }

    database_user { 'bob@localhost':
      password_hash => mysql_password('foo')
    }

    database_grant { 'user@localhost/database':
      privileges => ['all'] ,
      # Or specify individual privileges with columns from the mysql.db table:
      # privileges => ['Select_priv', 'Insert_priv', 'Update_priv', 'Delete_priv']
    }

A resource default can be specified to handle dependency:

    Database {
      require => Class['mariadb::server'],
    }
