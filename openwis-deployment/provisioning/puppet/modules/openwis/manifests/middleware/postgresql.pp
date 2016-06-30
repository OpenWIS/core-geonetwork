class openwis::middleware::postgresql (
    $postgresql_version = 9.5,
    $postgis_version    = 2.2,
)
{
    include openwis

    $postgresql_short_version = regsubst("${postgresql_version}", '^([0-9]*)\.([0-9]*)$', '\1\2')
    $postgis_major_version    = regsubst("${postgis_version}", '^([0-9]*)\.([0-9]*)$', '\1')
    $postgis_short_version    = regsubst("${postgis_version}", '^([0-9]*)\.([0-9]*)$', '\1\2')

    #==============================================================================
    # Add PostgreSQL repository
    #==============================================================================
    yumrepo { "postgres_${postgresql_short_version}":
      baseurl  => "http://yum.postgresql.org/${postgresql_version}/redhat/rhel-7-x86_64/",
      descr    => "PosrgrSQL ${postgresql_version} repository",
      enabled  => 1,
      gpgcheck => 0,
    }

    #==============================================================================
    # Install required packages
    #==============================================================================
    package { ["postgresql${postgresql_short_version}",
               "postgresql${postgresql_short_version}-server",
               "postgresql${postgresql_short_version}-libs",
               "postgresql${postgresql_short_version}-contrib",
               "postgresql${postgresql_short_version}-devel"]:
      ensure  => latest,
      require => Yumrepo["postgres_${postgresql_short_version}"]
    } ->
    package { ["epel-release"]:
      ensure => latest,
    } ->
    package { ["postgis${postgis_major_version}_${postgresql_short_version}",
               "ogr_fdw${postgresql_short_version}", #
               "pgrouting_${postgresql_short_version}"]:
      ensure => latest,
    }

    #==============================================================================
    # Configure PostgreSQL, initialise database, enable & start services
    #==============================================================================
    exec { "initdb":
        command => "/usr/pgsql-${postgresql_version}/bin/postgresql${postgresql_short_version}-setup initdb",
        creates => "/var/lib/pgsql/${postgresql_version}/initdb.log",
        notify  => Service["postgresql-${postgresql_version}"],
        require => Package["postgresql${postgresql_short_version}-server"]
        } ->
        file_line { "postgresql.conf: listen on all interfaces":
            path  => "/var/lib/pgsql/${postgresql_version}/data/postgresql.conf",
            line  => "listen_addresses = '*'",
            match => "^.?listen_addresses",
            notify  => Service["postgresql-${postgresql_version}"],
        } ->
        file_line { "pg_hba.conf: enable remote password connections":
            path  => "/var/lib/pgsql/${postgresql_version}/data/pg_hba.conf",
            line  => "host    all             all             0.0.0.0/0               md5",
            match => "host    all             all             127.0.0.1/32            ident",
            notify  => Service["postgresql-${postgresql_version}"],
        }

    service { "postgresql-${postgresql_version}":
      ensure => running,
      enable => true,
    }
}
