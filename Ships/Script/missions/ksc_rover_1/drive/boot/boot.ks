@lazyglobal off.
clearscreen.
set terminal:charwidth to 6.
set terminal:width to 96.
set terminal:height to 24.
set ship:control:pilotmainthrottle to 0.
print "wah".

function runonce_dir {
  parameter path_from_root.//string representation

  local orig_path is path().
  local item_path is 0.
  local contents is 0.

  cd(path(path_from_root)).
  list files in contents.
  for item in contents {
    set item_path to path_from_root + "/" + item:name.
    print "import: " + item_path.
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

print "initialize app.".
runoncepath("/app/init").
print "boot.ks completed.".
