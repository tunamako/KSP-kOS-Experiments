{
  function onboard_disks {
    local cpus is ship:modulesnamed("kOSProcessor").
    local disks is lex().
    for cpu in cpus {
      disks:add(cpu:volume:name, cpu:volume).
    }
    return disks.
  }

  function verify_space {
    parameter
      from_path,
      to_path is path():segments:join("/").

    local filesize is path(from_path):readall:length.
    return path(to_path):volume:freespace >= filesize.
  }

  function copy_file {
    parameter
      from_path,
      to_path is path():segments:join("/").

    local can_transfer is true.
    for disk in list(path(from_path):volume, path(to_path):volume) {
      if disk = archive and not addons:rt:haskscconnection(ship) set can_transfer to false.
      else if not onboard_disks():haskey(disk:name) set can_transfer to false.
    }
    if can_transfer copypath(from_path, to_path).
    return can_transfer.
  }

  export(lex(
    "version", "0.0.1",
    "onboard_disks", onboard_disks@,
    "verify_space", verify_space@,
    "copy_file", copy_file@
  )).
}
