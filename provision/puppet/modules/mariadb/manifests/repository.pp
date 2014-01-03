class mariadb::repository {

  if $::rfc1918_gateway == 'true' {
    exec { 'mariadb-apt-key':
     path        => '/usr/bin:/bin:/usr/sbin:/sbin',
     command     => "apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 1BB943DB --keyserver-options http-proxy=\"${::http_proxy}\"",
     unless      => 'apt-key list | grep 1BB943DB >/dev/null 2>&1',
    }

  } else {
    apt::key { 'mariadb':
      key         => '1BB943DB',
      key_server => 'pgp.mit.edu',
    }
  }

  apt::source { 'mariadb':
    location    => 'http://mirror.aarnet.edu.au/pub/MariaDB/repo/5.5/ubuntu',
    repos       => 'main',
    key         => '1BB943DB',
  }

}
