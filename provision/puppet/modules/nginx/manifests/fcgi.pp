# Class: nginx::fcgi
#
# Manage nginx fcgi configuration.
# Provide nginx::fcgi::site
#
# Templates :
# * nginx/includes/fastcgi_params.erb
#
class nginx::fcgi inherits nginx {
  nginx::site_include { 'fastcgi_params':
    content => template('nginx/includes/fastcgi_params.erb'),
  }
}
