# Define: nginx::site
#
# Install a nginx site in /etc/nginx/sites-available (and symlink in /etc/nginx/sites-enabled).
#
#
# Parameters :
# * ensure: typically set to "present" or "absent". Defaults to "present"
# * content: site definition (should be a template).
#
define nginx::site($ensure='present', $content='') {
  case $ensure {
    'present' : {
      nginx::install_site { $name:
        content => $content
      }
    }
    'absent' : {
      exec { "/bin/rm -f /etc/nginx/sites-enabled/${name}":
        onlyif  => "/bin/sh -c '[ -L /etc/nginx/sites-enabled/${name} ] && \
          [ /etc/nginx/sites-enabled/$name -ef /etc/nginx/sites-available/${name} ]'",
        notify  => Service['nginx'],
        require => Package['nginx'],
      }
    }
    default: { err ("Unknown ensure value: '$ensure'") }
  }
}
