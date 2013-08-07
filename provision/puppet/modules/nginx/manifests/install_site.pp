# Define: install_site
#
# Install nginx vhost
# This definition is private, not intended to be called directly
#
define nginx::install_site($content=undef) {
  # first, make sure the site config exists
  case $content {
    undef: {
      file { "/etc/nginx/sites-available/${name}":
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        alias   => "sites-${name}",
        notify  => Service['nginx'],
        require => Package['nginx'],
      }
    }
    default: {
      file { "/etc/nginx/sites-available/${name}":
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        alias   => "sites-$name",
        content => $content,
        require => Package['nginx'],
        notify  => Service['nginx'],
      }
    }
  }

  # now, enable it.
  exec { "ln -s /etc/nginx/sites-available/${name} /etc/nginx/sites-enabled/${name}":
    unless  => "/bin/sh -c '[ -L /etc/nginx/sites-enabled/${name} ] && \
      [ /etc/nginx/sites-enabled/${name} -ef /etc/nginx/sites-available/${name} ]'",
    path    => ['/usr/bin/', '/bin/'],
    notify  => Service['nginx'],
    require => File["sites-${name}"],
  }
}
