# Class: mariadb::php
#
# This class installs the php libs for mariadb.
#
# Parameters:
#   [*ensure*]   - ensure state for package.
#                  can be specified as version.
#   [*packagee*] - name of package
#
class mariadb::php(
  $package_name   = $mariadb::params::php_package_name,
  $package_ensure = 'present'
) inherits mariadb::params {

  package { 'php-mysql':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
