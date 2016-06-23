class openwis::portal (
    $use_local_portal_war = false,
    $local_portal_war = undef,
    $remote_portal_war = undef
)
{
    include openwis
    
    # ensure Apache Tomcat installed & configured
    require openwis::middleware::tomcat
    
    $scripts_dir    = $openwis::scripts_dir
    $config_src_dir = $openwis::config_src_dir
    
    #==============================================================================
    # Configure scripts
    #==============================================================================
    file {["${config_src_dir}/portal", "${config_src_dir}/portal/config-node", "${config_src_dir}/portal/config-db"]:
        ensure => directory
    } ->
    file {"${config_src_dir}/portal/config-node/srv.xml":
        ensure  => file,
        content => epp("openwis/portal/config-node/srv.xml")
    } ->
    file {"${config_src_dir}/portal/config-db/jdbc.properties":
        ensure  => file,
        content => epp("openwis/portal/config-db/jdbc.properties")
    } ->
    file {"${config_src_dir}/portal/config-db/postgres.xml":
        ensure  => file,
        content => epp("openwis/portal/config-db/postgres.xml")
    } ->
    file {"${scripts_dir}/deploy-portal.sh":
        ensure  => file,
        mode    => "0666",
        content => epp("openwis/scripts/deploy-portal.sh", {
            use_local_portal_war => $use_local_portal_war,
            local_portal_war     => $local_portal_war,
            remote_portal_war    => $remote_portal_war
        })
    }

    #==============================================================================
    # Deploy portal
    #==============================================================================
#    exec { deploy-portal:
#        command => "${scripts_dir}/deploy-portal.sh",
#        creates => "/usr/share/tomcat/webapps"
#    }
}
