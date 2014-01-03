# Class: mariadb::server
#
# manages the installation of the mariadb server.  manages the package, service,
# my.cnf
#
# Parameters:
#   [*package_names*] - array of package names to install
#   [*service_name*]  - name of service
#   [*config_hash*]   - hash of config parameters that need to be set.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mariadb::server (
  $package_names           = $mariadb::params::server_package_names,
  $package_ensure          = $mariadb::params::server_package_ensure,
  $service_name            = $mariadb::params::service_name,
  $service_provider        = $mariadb::params::service_provider,
  $client_package_names    = $mariadb::params::client_package_names,
  $client_package_ensure   = $mariadb::params::client_package_ensure,
  $debiansysmaint_password = undef,
  $config_hash             = {},
  $enabled                 = true,
  $manage_service          = true
) inherits mariadb::params {

  class { 'mariadb':
    package_names  => $client_package_names,
    package_ensure => $client_package_ensure
  }

  Class['mariadb::server'] -> Class['mariadb::config']

  $config_class = { 'mariadb::config' => $config_hash }

  create_resources( 'class', $config_class )

  package { $package_names:
    ensure  => $package_ensure,
    require => Package[$client_package_names] 
  }

  file { '/var/log/mysql/error.log':
    owner => mysql,
    require => Package[$package_names],
  }

  #if $debiansysmaint_password != undef {
  #  file { '/etc/mysql/debian.cnf':
  #    content => template('mariadb/debian.cnf.erb'),
  #  }
  #}

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  if $manage_service {
    service { 'mariadb':
      ensure   => $service_ensure,
      name     => $service_name,
      enable   => $enabled,
      require  => Package[$package_names],
      provider => $service_provider,
    }
  }
}
