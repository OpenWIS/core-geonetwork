Package {
	allow_virtual => false,
}

case $::hostname {
  # Database Server
  "ow4dev-db": {
    class { openwis::database:
    }
  }

  # Data Services Server
  "ow4dev-data": {
    class { openwis::data_services:
    }
  }

  # Portal Server
  "ow4dev-portal": {
    class { openwis::apache_proxy:
    }

    class { openwis::portal:
    }
  }
}
