# == Class: rsnapshot::install
#
# Installs the rsnapshot package.
class rsnapshot::install inherits rsnapshot {

  package { $rsnapshot::package_name:
    ensure => $rsnapshot::package_ensure,
  }

}

