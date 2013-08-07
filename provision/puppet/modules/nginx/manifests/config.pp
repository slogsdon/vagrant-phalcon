# Define: nginx::config
#
# Define a nginx config snippet. Places all config snippets into
# /etc/nginx/conf.d, where they will be automatically loaded by http module
#
#
# Parameters :
# * ensure: typically set to "present" or "absent". Defaults to "present"
# * content: set the content of the config snipppet.
#            Defaults to 'template("nginx/${name}.conf.erb")'
# * order: specifies the load order for this config snippet. Defaults to "500"
#
define nginx::config($ensure='present', $content=undef, $order='500') {
  $real_content = $content ? {
    undef   => template("nginx/${name}.conf.erb"),
    default => $content,
  }

  file { "${nginx::nginx_conf}/${order}-${name}.conf":
    ensure  => $ensure,
    content => $real_content,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => Service['nginx'],
  }
}

