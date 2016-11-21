//fix launch startup
@lazyglobal off.
print "wah".
set ship:control:pilotmainthrottle to 0.
gear off.
set terminal:charwidth to 6.
set terminal:width to 96.
set terminal:height to 24.
wait 1.

//delete current bootstuffs
deletepath("/boot/").

//get the mission folder from this part's name tag
local cpu_tag is core:part:tag.
local mission_name is 0.
if cpu_tag:contains(".") {
  set mission_name to cpu_tag:split(".")[0].
} else {
  set mission_name to cpu_tag.
}

//download the /drive folder
local archive_dir is "0:/missions/"+mission_name+"/drive/".
local contents is 0.
cd(archive_dir).
list files in contents.
for item in contents {
  local item_path is archive_dir + "/" + item:name.
  copypath(item_path, core:volume:name+":/").
}

//reboot
reboot.
