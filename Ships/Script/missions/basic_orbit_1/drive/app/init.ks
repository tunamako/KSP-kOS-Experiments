runoncepath("lib/lib_import").
global rm is import("lib/lib_rm").
global asc is import("lib/lib_ascent").
global circ is import("lib/lib_circ").
global hoh is import("lib/lib_hohmann").
global merge is import("lib/list_merge").


local runmode is rm["get"]().
hudtext(
  "Loading runmode: " + char(34) + runmode + char(34),
  5, 2, 30, white, true).
runoncepath(runmode).
reboot.
