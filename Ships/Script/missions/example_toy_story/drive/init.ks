runoncepath("import").
global rm is import("lib/runmode").

local runmode is rm["get"]().
hudtext(
  "Loading runmode: " + char(34) + runmode + char(34),
  5, 2, 30, white, true).
runoncepath(runmode).
reboot.
