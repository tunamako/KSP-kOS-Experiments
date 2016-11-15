@lazyglobal off. clearscreen. set ship:control:pilotmainthrottle to 0. gear off. //fix various kos and ksp startup bugs.

wait 1.
wait until addons:rt:haskscconnection(ship).
deletepath("/boot/").

local imports is list(
  "/app/",
  "/boot/",
  "/lib/",
  "/update/",
  "/version.txt"
).

//somehow get the nametag of the processor from within.
local local_kos_part is 0.
local kos_part_lists is list(
  ship:partsnamed("SR.ProbeCore"),
  ship:partsnamed("kOSMachine1m"),
  ship:partsnamed("kOSkal9000"),
  ship:partsnamed("kOSMachineRad"),
  ship:partsnamed("kOSMachine0m")
).
local kos_parts is list().
for sublist in kos_part_lists {
  for sublist_part in sublist {
    kos_parts:add(sublist_part).
  }
}
for kos_part in kos_parts {
  local cpu is kos_part:getmodule("kOSProcessor").
  if cpu:volume = core:currentvolume {
    set local_kos_part to kos_part.
    break.
  }
}

local mission_name is 0.
if local_kos_part:tag:contains(".") {
  set mission_name to local_kos_part:tag:split(".")[0].
} else {
  set mission_name to local_kos_part:tag.
}

local archive_path is "0:/missions/" + mission_name.
for item in imports {
  local item_path is archive_path + item.
  if exists(item_path) {copypath(item_path, "/").}
}
reboot.
