# == Class: rsnapshot::config
#
# manage host configs
class rsnapshot::config (
  $hosts      = $rsnapshot::hosts,
) {
  # these are global settings, no point in setting them per host
  $config_version         = $rsnapshot::params::config_version
  $lockpath               = pick($rsnapshot::lockpath, $rsnapshot::params::config_lockpath)
  $conf_d                 = pick($rsnapshot::conf_d, $rsnapshot::params::conf_d)
  # make sure lock path and conf path exist
  file { $conf_d:
    ensure => 'directory',
  }
  file { $lockpath:
    ensure => 'directory',
  }

  notify {"Hosts is: $hosts ": }
  $hosts.each |String $host, Hash $hash | {
    $snapshot_root          = pick($hash['snapshot_root'], $rsnapshot::params::config_snapshot_root)
    $backup                = pick($hash['backup'], $rsnapshot::params::config_backup)
    $backup_user            = pick($hash['backup_user'], $rsnapshot::params::config_backup_user)
    $backup_defaults        = pick($hash['backup_defaults'], $rsnapshot::params::config_backup_defaults)
    if $backup_defaults {
      $backups = merge($backup, $rsnapshot::params::config_backup) 
    } else {
      $backups = $backup   
    }

    $cmd_cp                 = pick($hash['cmd_cp'], $rsnapshot::params::config_cmd_cp)
    $cmd_rm                 = pick($hash['cmd_rm'], $rsnapshot::params::config_cmd_rm)
    $cmd_rsync              = pick($hash['cmd_rsync'], $rsnapshot::params::config_cmd_rsync)
    $cmd_ssh                = pick($hash['cmd_ssh'], $rsnapshot::params::config_cmd_ssh)
    $cmd_logger             = pick($hash['cmd_logger'], $rsnapshot::params::config_cmd_logger)
    $cmd_du                 = pick($hash['cmd_du'], $rsnapshot::params::config_cmd_du)
    $cmd_rsnapshot_diff     = pick_undef($hash['cmd_rsnapshot_diff'], $rsnapshot::params::config_cmd_rsnapshot_diff)
    $cmd_preexec            = pick_undef($hash['cmd_preexec'], $rsnapshot::params::config_cmd_preexec)
    $cmd_postexec           = pick_undef($hash['cmd_postexec'], $rsnapshot::params::config_cmd_postexec)
    $use_lvm                = pick_undef($hash['use_lvm'], $rsnapshot::params::config_use_lvm)
    $linux_lvm_cmd_lvcreate = pick_undef($hash['linux_lvm_cmd_lvcreate'], $rsnapshot::params::config_linux_lvm_cmd_lvcreate)
    $linux_lvm_cmd_lvremove = pick_undef($hash['linux_lvm_cmd_lvremove'], $rsnapshot::params::config_linux_lvm_cmd_lvremove)
    $linux_lvm_cmd_mount    = pick_undef($hash['linux_lvm_cmd_mount'], $rsnapshot::params::config_linux_lvm_cmd_mount)
    $linux_lvm_cmd_umount   = pick_undef($hash['linux_lvm_cmd_umount'], $rsnapshot::params::config_linux_lvm_cmd_umount)
    $linux_lvm_snapshotsize = pick_undef($hash['linux_lvm_snapshotsize'], $rsnapshot::params::config_linux_lvm_snapshotsize)
    $linux_lvm_snapshotname = pick_undef($hash['linux_lvm_snapshotname'], $rsnapshot::params::config_linux_lvm_snapshotname)
    $linux_lvm_vgpath       = pick_undef($hash['linux_lvm_vgpath'], $rsnapshot::params::config_linux_lvm_vgpath)
    $linux_lvm_mountpath    = pick_undef($hash['linux_lvm_mountpath'], $rsnapshot::params::config_linux_lvm_mountpath)
    $no_create_root         = pick_undef($hash['no_create_root'], $rsnapshot::params::config_no_create_root)
    notice("no_create_root for $host is $no_create_root ")
    $lockfile               = "${lockpath}/${host}.pid"
    $logpath                = pick($hash['logpath'], $rsnapshot::logpath, $rsnapshot::params::config_logpath)
    $logfile                = "${logpath}/${host}.log"
    $verbose                = pick($hash['verbose'], $rsnapshot::params::config_verbose)
    $loglevel               = pick($hash['loglevel'], $rsnapshot::params::config_loglevel)
    $stop_on_stale_lockfile = pick_undef($hash['stop_on_stale_lockfile'], $rsnapshot::params::config_stop_on_stale_lockfile)
    $rsync_short_args       = pick($hash['rsync_short_args'], $rsnapshot::params::config_rsync_short_args)
    $rsync_long_args        = pick_undef($hash['rsync_long_args'], $rsnapshot::params::config_rsync_long_args)
    $ssh_args               = pick_undef($hash['ssh_args'], $rsnapshot::params::config_ssh_args)
    $du_args                = pick_undef($hash['du_args'], $rsnapshot::params::config_du_args)
    $one_fs                 = pick_undef($hash['one_fs'], $rsnapshot::params::config_one_fs)
    # one of both interval or retain must be present
    $interval               = pick($hash['interval'], $rsnapshot::params::config_interval)
    $retain                 = pick_undef($hash['retain'], $rsnapshot::params::config_retain)
    notice("interval for $host is $interval ")
    if ! ($interval and  $retain )  {
      $interval               = pick($hash['interval'], $rsnapshot::params::config_interval)
    }
    $include                = pick_undef($hash['include'], $rsnapshot::params::config_include)
    $exclude                = pick_undef($hash['exclude'], $rsnapshot::params::config_exclude)
    $include_file           = pick_undef($hash['include_file'], $rsnapshot::params::config_include_file)
    $exclude_file           = pick($hash['exclude_file'], $rsnapshot::params::config_exclude_file, "${conf_d}/${host}.exclude")
    $link_dest              = pick_undef($hash['link_dest'], $rsnapshot::params::config_link_dest)
    if $link_dest { $link_dest_num = bool2num($link_dest) }
    $sync_first             = pick_undef($hash['sync_first'], $rsnapshot::params::config_sync_first)
    if $sync_first { $sync_first_num = bool2num($sync_first)  }
    $rsync_numtries         = pick_undef($hash['rsync_numtries'], $rsnapshot::params::config_rsync_numtries)
    $use_lazy_deletes       = pick_undef($hash['use_lazy_deletes'], $rsnapshot::params::config_use_lazy_deletes)
    if $use_lazy_deletes { $use_lazy_deletes_num = bool2num($use_lazy_deletes)   }
    $backup_scripts         = pick_undef($hash['backup_scripts'], $rsnapshot::params::config_backup_scripts)

    $snapshot_dir           = "${config_snapshot_root}/${host}"
    $config                 = "${conf_d}/${host}.rsnapshot.conf"

  
    file { $config:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('rsnapshot/rsnapshot.erb')
    }
  }
}

