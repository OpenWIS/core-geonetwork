class openwis (
    $provisioning_root_dir        = "/tmp/provisioning",
    $touch_files_dir              = "/home/openwis/touchfiles",
    $logs_root_dir                = "/home/openwis/logs",
    $db_server_host_name,
    $db_user_password             = "openwis",
    $openwis_opt_dir              = "/var/opt/openwis",
    $data_services_base_url       = "http://localhost:8180",
    $management_services_base_url = "http://localhost:8180"
)
{
    $scripts_dir      = "${provisioning_root_dir}/scripts"
    $config_src_dir   = "${provisioning_root_dir}/config"
    $working_dir      = "${provisioning_root_dir}/working"
    $downloads_dir    = "${provisioning_root_dir}/downloads"
    $openwis_logs_dir = "${logs_root_dir}/openwis"

    # default attributes
    File {
      owner => "openwis",
      group => "openwis",
    }

    #==========================================================================
    # Install common utility packages
    #==========================================================================
    package { [unzip, wget]:
      ensure => latest,
    }

    #==========================================================================
    # Ensure OpenWIS user && group exists
    #==========================================================================
    group { openwis:
        ensure => present
    } ->
    user { openwis:
        ensure => present,
        gid    => "openwis",
        home   => "/home/openwis",
        shell  => "/bin/bash"
    }

    #==========================================================================
    # Manage folders & links
    #==========================================================================
    file { ["/home/openwis", "${openwis_opt_dir}"]:
        ensure => directory,
        owner  => "openwis",
        group  => "openwis"
    } ->
    file { ["${touch_files_dir}", "${logs_root_dir}", "${openwis_logs_dir}"]:
        ensure => directory,
    }

    $dirtree = dirtree("${provisioning_root_dir}")
    ensure_resource(file, $dirtree, {
        ensure => directory
    })

    file { ["${scripts_dir}",
            "${config_src_dir}",
            "${working_dir}",
            "${downloads_dir}"]:
        ensure  => directory,
        require => File["${provisioning_root_dir}"]
    }

    #==============================================================================
    # Configure scripts
    #==============================================================================
    file { "${scripts_dir}/setenv.sh":
        ensure  => file,
        mode    => "0774",
        content => dos2unix(epp("openwis/scripts/setenv.sh", {
            config_src_dir => $config_src_dir,
            working_dir    => $working_dir,
            downloads_dir  => $downloads_dir
        })),
        require => File["${scripts_dir}"]
    } ->
    file { "${scripts_dir}/functions.sh":
        ensure  => file,
        mode    => "0774",
        content => dos2unix(epp("openwis/scripts/functions.sh"))
    }

}
