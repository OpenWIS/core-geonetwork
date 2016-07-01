Package {
	allow_virtual => false,
}

$provisioning_root_dir = hiera(openwis::provisioning_root_dir)
$scripts_dir = "${provisioning_root_dir}/scripts"

# ensure server-specific folder exists
file {"/vagrant/${::hostname}":
	ensure => directory,
	owner  => "vagrant",
	group  => "vagrant"
}

# ensure 'logs' & 'openwis opt' folders are removed
file {["/vagrant/${::hostname}/logs", "/vagrant/${::hostname}/openwis"]:
	ensure => absent,
	force => true
}

# create links to shell scripts
file {"/home/vagrant/bin/initialise-db":
    ensure => link,
    target => "${scripts_dir}/initialise-db.sh"
}
