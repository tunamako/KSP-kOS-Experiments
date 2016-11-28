toggle ag1.
runoncepath("/import").
global rm is import("/lib/runmode").
local runmode is rm["get"]().
hudtext(
  "Initializing runmode: "+char(34)+runmode+char(34),
  5, 2, 30, white, true).
runoncepath(runmode).

hudtext(
  "Runmode "+char(34)+runmode+char(34)+" complete. Next runmode is: "+char(34)+rm["get"]()+char(34),
  5, 2, 30, white, true).
  hudtext(
    "Rebooting...",
    5, 2, 30, white, true).
reboot.
