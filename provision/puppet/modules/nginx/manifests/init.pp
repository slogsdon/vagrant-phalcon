# Class: nginx
#
# Install nginx.
#
# Parameters:
# * $nginx_user. Defaults to 'www-data'.
# * $nginx_worker_processes. Defaults to '1'.
# * $nginx_worker_connections. Defaults to '1024'.
#
# Create config directories :
# * /etc/nginx/conf.d for http config snippet
# * /etc/nginx/includes for sites includes
# * /etc/nginx/sites-available for sites configs
# * /etc/nginx/sites-enabled for sites links
#
# Provide 3 definitions :
# * nginx::config (http config snippet)
# * nginx::site (http site)
# * nginx::site_include (site includes)
#
# Templates:
#   - nginx.conf.erb => /etc/nginx/nginx.conf
#
class nginx {
  $nginx_includes = '/etc/nginx/includes'
  $nginx_conf = '/etc/nginx/conf.d'

  $nginxversion = $nginxversion ? {
    undef => '1.0.0',
    default => $nginxversion
  }

  $real_nginx_user = $::nginx_user ? {
    undef   => 'www-data',
    default => $::nginx_user
  }

  $real_nginx_worker_processes = $::nginx_worker_processes ? {
    undef   => '1',
    default => $::nginx_worker_processes
  }

  $real_nginx_worker_connections = $::nginx_worker_connections ? {
    undef   => '1024',
    default => $::nginx_worker_connections
  }

  if ! defined(Package['nginx']) { package { 'nginx': ensure => installed }}

  #restart-command is a quick-fix here, until http://projects.puppetlabs.com/issues/1014 is solved
  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => File['/etc/nginx/nginx.conf'],
    restart    => '/etc/init.d/nginx reload'
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('nginx/nginx.conf.erb'),
    notify  => Service['nginx'],
    require => Package['nginx'],
  }

  file { $nginx_conf:
    ensure  => directory,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['nginx'],
  }

  file { '/etc/nginx/ssl':
    ensure  => directory,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['nginx'],
  }

  file { $nginx_includes:
    ensure  => directory,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['nginx'],
  }

  file { ['/etc/nginx/sites-available', '/etc/nginx/sites-enabled']:
    ensure  => directory,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['nginx'],
  }

  # Nuke default files
  file { '/etc/nginx/fastcgi_params':
    ensure  => absent,
    require => Package['nginx'],
  }
}
