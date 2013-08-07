# Nginx Recipe #
Author	: Benoit CATTIE <puppet@benoit.cattie.net>
Version	: 0.2
Licence : Apache

Basic module for configuring nginx via puppet.

Based in part on apache2 module code by Sam Quigley <sq@wesabe.com>, Tim Stoop <tim.stoop@gmail.com> and David Schmitt <david@schmitt.edv-bus.at>

## Class: nginx ##

Parameters (used in nginx.conf.erb) :
       * $nginx_user. Defaults to 'www-data'. 
       * $nginx_worker_processes. Defaults to '1'.
       * $nginx_worker_connections. Defaults to '1024'.

Install nginx.
Create config directories :
	* /etc/nginx/conf.d for http config snippet
	* /etc/nginx/includes for sites includes
	* /etc/nginx/sites-enabled
	* /etc/nginx/sites-available
	* /etc/nginx/ssl

Provide 4 definitions : 
	* nginx::config (http config snippet)
	* nginx::site (http site)
	* nginx::site_include (site includes)
	* nginx::fcgi::site (fcgi php site)

Templates:
	- nginx.conf.erb => /etc/nginx/nginx.conf


### Define nginx::config ### 

Installs a config snippet in /etc/nginx/conf.d. 

Parameters :
	* ensure: typically set to "present" or "absent". Defaults to "present"
	* content: set the content of the config snipppet. Defaults to 'template("nginx/${name}.conf.erb")'
	* order: specifies the load order for this config snippet. Defaults to "500"


###  Define: nginx::site ###

Install a nginx site in /etc/nginx/sites-available (and symlink in /etc/nginx/sites-enabled). 

Parameters :
	* ensure: typically set to "present" or "absent". Defaults to "present"
	* content: site definition (should be a template).

###  Define: nginx::site_include ###

Define: site_include

Define a site config include in /etc/nginx/includes

Parameters :
	* ensure: typically set to "present" or "absent". Defaults to "present"
	* content: include definition (should be a template).


## Class nginx::fcgi ##

Manage nginx fcgi configuration.
Provide nginx::fcgi::site 

Templates :
	* nginx/includes/fastcgi_params.erb

###  Define: nginx::fcgi::site  ###

Create a fcgi site config from template using parameters.
You can use my php5-fpm class to manage fastcgi servers.

Parameters :
 	* ensure: typically set to "present" or "absent". Defaults to "present"
 	* root: document root (Required)
	* index: nginx index directive. Defaults to "index.php"
	* fastcgi_pass : port or socket on which the FastCGI-server is listening (Required)
	* server_name : server_name directive (could be an array)
	* listen : address/port the server listen to. Defaults to 80. Auto enable ssl if 443
	* access_log : custom acces logs. Defaults to /var/log/nginx/$name_access.log
	* include : custom include for the site (could be an array). Include files must exists
	   to avoid nginx reload errors. Use with nginx::site_include
	* ssl_certificate : ssl_certificate path. If empty auto-generating ssl cert
	* ssl_certificate_key : ssl_certificate_key path. If empty auto-generating ssl cert key 
   See http://wiki.nginx.org for details.

Templates :
	* nginx/fcgi_site.erb

Sample Usage :

        include nginx
        include nginx::fcgi

        nginx::fcgi::site {"default":
                root            => "/var/www/nginx-default",
                fastcgi_pass    => "127.0.0.1:9000",
                server_name     => ["localhost", "$hostname", "$fqdn"],
         }

        nginx::fcgi::site {"default-ssl":
                listen          => "443",
                root            => "/var/www/nginx-default",
                fastcgi_pass    => "127.0.0.1:9000",
                server_name     => "$fqdn",
         }

## CHANGELOG ##
- v0.2 : * ssl support
