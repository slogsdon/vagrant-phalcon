class phpqatools::redhat {
	

	yumrepo { "IUS":
		baseurl => "http://dl.iuscommunity.org/pub/ius/stable/Redhat/5/$architecture",
		descr => "IUS Community repository",
		enabled => 1,
		gpgcheck => 0
	}

	class { "pear":
		package => "php53u-pear",
		require => Yumrepo["IUS"],
	}
}