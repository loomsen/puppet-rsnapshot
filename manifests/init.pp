# == Class: rsnapshot
#
# Manages rsnapshot.
#
# === Parameters
#
class rsnapshot (
  $hosts                         = $rsnapshot::params::hosts,
  $conf_d                        = $rsnapshot::params::conf_d,
  $logpath                       = $rsnapshot::params::config_logpath,
  $lockpath                      = $rsnapshot::params::config_lockpath,
  $default_backup                = $rsnapshot::params::config_default_backup,
) inherits rsnapshot::params {

  #  anchor { 'rsnapshot::begin': } ->
  #class { 'rsnapshot::install': } ->
  #class { 'rsnapshot::config': } ->
  #anchor { 'rsnapshot::end': }
  if $hosts {
    class { 'rsnapshot::config': }
    contain 'rsnapshot::config'
  }
}

