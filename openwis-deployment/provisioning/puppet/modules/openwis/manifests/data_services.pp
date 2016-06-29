class openwis::data_services ()
{
    include openwis

    # ensure Apache HTTPD installed & configured
    require openwis::middleware::jboss_as

}
