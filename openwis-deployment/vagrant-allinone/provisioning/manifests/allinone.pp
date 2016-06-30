Package {
	allow_virtual => false,
}

# Apache proxy has no hard dependencies
class { openwis::apache_proxy:
}

# database, data services & portal must be provisioned in correct order
class { openwis::database:
} ->
class { openwis::data_services:
} ->
class { openwis::portal:
}
