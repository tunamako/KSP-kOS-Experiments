wait until addons:rt:haskscconnection(ship).
local contents is 0.
list files in contents.
for item in contents {
deletepath(core:volume:name+":/"+item:name).
}
local archive_dir is "0:/missions/munar_polar_1/mission step 2 - munar impact trajectory".
cd(archive_dir).
list files in contents.
for item in contents {
  local item_path is archive_dir + "/" + item:name.
  copypath(item_path, core:volume:name+":/").
}
cd(core:volume:name+":/").
