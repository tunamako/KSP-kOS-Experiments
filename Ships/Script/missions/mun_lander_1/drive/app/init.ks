runoncepath("lib/lib_import").
global rm is import("lib/lib_rm").
global asc is import("lib/lib_ascent").
global circ is import("lib/lib_circ").
global sci is import("lib/lib_science").
global hoh is import("lib/lib_hohmann").

local runmode is rm["get"]().
hudtext(
  "Loading runmode: " + char(34) + runmode + char(34),
  5, 2, 30, white, true).
runoncepath(runmode).
reboot.
