class openwis::middleware::java (
  $java_version = "java-1.7.0-openjdk"
)
{
  require openwis

  #==============================================================================
  # Install Required packages
  #==============================================================================
  package { ["${java_version}", "${java_version}-devel", "${java_version}-headless"]:
    ensure => latest,
  }
}
