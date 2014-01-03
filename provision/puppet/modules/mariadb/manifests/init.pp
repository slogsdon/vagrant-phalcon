# Class: mariadb
#
#   This class installs mariadb client software.
#
# Parameters:
#   [*client_package_names*] - Array of names of the mariadb client packages.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mariadb (
  $package_names  = $mariadb::params::client_package_names,
  $package_ensure = 'present'
) inherits mariadb::params {

  package { $package_names:
    ensure => $package_ensure,
  }

}
