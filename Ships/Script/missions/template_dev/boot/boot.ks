@lazyglobal off. clearscreen. set ship:control:pilotmainthrottle to 0.


function runonce_dir {
  parameter path_from_root.//string representation

  local orig_path is path().
  local item_path is 0.
  local contents is 0.

  cd(path(path_from_root)).
  list files in contents.
  for item in contents {
    set item_path to path_from_root + "/" + item:name.
    print item_path.
    if not item:isfile {
      runonce_dir(item_path).
    } else if item:extension = "ks" or item:extension = "ksm" {
      runoncepath(item_path).
    }
  }
  cd(orig_path).

  return.
}

//load libraries
runonce_dir("/lib").//working

local skip_update_flag is "boot/skipupdate.txt".
local update_skipped is exists(skip_update_flag).

if update_skipped {deletepath(skip_update_flag).}
else {runoncepath("update/update").}
runpath("app/init").
print "boot.ks completed.".
