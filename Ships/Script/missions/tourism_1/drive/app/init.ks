runoncepath("lib/lib_import").
global rm is import("lib/lib_rm").
global asc is import("lib/lib_ascent").
global circ is import("lib/lib_circ").
global hoh is import("lib/lib_hohmann").
global timeStart is time:seconds.
global timeToOrbit is 3600. //14400 for "kickstartTourism" and 3600 for the repeatable "lkoTourist"

local runmode is rm["get"]().
hudtext(
  "Loading runmode: " + char(34) + runmode + char(34),
  5, 2, 30, white, true).
runoncepath(runmode).
reboot.
