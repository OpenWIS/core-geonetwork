class openwis::database ()
{
    require openwis

    # ensure PostgeSQL installed & configured
    require openwis::middleware::postgresql

    $scripts_dir        = $openwis::scripts_dir
    $config_src_dir     = $openwis::config_src_dir
    $touchfiles_dir     = $openwis::touchfiles_dir
    $postgresql_version = $openwis::middleware::postgresql::postgresql_version
    $postgis_version    = $openwis::middleware::postgresql::postgis_version
    $db_user_password   = $openwis::db_user_password

    #==============================================================================
    # Configure scripts
    #==============================================================================
    file { "${config_src_dir}/database":
        ensure => directory
    } ->
    file { "${config_src_dir}/database/openwis-roles.sql":
        ensure  => file,
        content => epp("openwis/database/openwis-roles.sql", {
            postgresql_version => $postgresql_version,
            postgis_version    => $postgis_version,
            db_user_password   => $db_user_password
        })
    } ->
    file { "${scripts_dir}/create-db.sh":
        ensure  => file,
        mode    => "0774",
        content => dos2unix(epp("openwis/scripts/create-db.sh", {
            postgresql_version => $postgresql_version,
            postgis_version    => $postgis_version
        }))
    }

    #==============================================================================
    # Create database
    #==============================================================================
    exec { "create-db":
        command => "${scripts_dir}/create-db.sh",
        require => File["${scripts_dir}/create-db.sh"]
    }
}
