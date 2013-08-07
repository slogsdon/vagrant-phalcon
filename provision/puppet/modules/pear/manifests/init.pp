class pear(
  $package = $pear::params::package
) inherits pear::params {

  # Install the PEAR package.
  if !defined(Package[$package]) {
    package { $package:
      ensure => installed,
    }
  }
}
