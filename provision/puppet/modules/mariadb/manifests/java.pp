# Class: mariadb::java
#
# This class installs the mariadb-java-connector.
#
# Parameters:
#   [*java_package_name*]  - The name of the mariadb java package.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mariadb::java (
  $package_name   = $mariadb::params::java_package_name,
  $package_ensure = 'present'
) inherits mariadb::params {

  package { 'mysql-connector-java':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
