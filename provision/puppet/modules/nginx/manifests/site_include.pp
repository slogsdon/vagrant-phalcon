# Define: site_include
#
# Define a site config include in /etc/nginx/includes
#
# Parameters :
# * ensure: typically set to "present" or "absent". Defaults to "present"
# * content: include definition (should be a template).
#
define nginx::site_include($ensure='present', $content='') {
  file { "${nginx::nginx_includes}/${name}.inc":
    ensure  => $ensure,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => $content,
    require => File[$nginx::nginx_includes],
    notify  => Service['nginx'],
  }
}

