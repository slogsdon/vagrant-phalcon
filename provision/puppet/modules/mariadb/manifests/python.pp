# Class: mariadb::python
#
# This class installs the python libs for mariadb.
#
# Parameters:
#   [*ensure*]       - ensure state for package.
#                        can be specified as version.
#   [*package_name*] - name of package
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mariadb::python(
  $package_name   = $mariadb::params::python_package_name,
  $package_ensure = 'present'
) inherits mariadb::params {

  package { 'python-mysqldb':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
