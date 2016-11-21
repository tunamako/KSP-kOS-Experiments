toggle ag1.
clearscreen.
set ship:control:pilotmainthrottle to 0.
runpath("1:/lib/lib_ascent.ks").
runpath("1:/lib/lib_circ.ks").
runpath("1:/lib/lib_science.ks").
runpath("1:/lib/list_merge.ks").
local targetAltitude is 71000.

lib["util"]["countdown"]().

stage.
if ship:altitude < targetAltitude {
    lib["util"]["ascend"](0, targetAltitude).
    print "Ascent complete".
}
if ship:orbit:periapsis < targetAltitude {
    toggle ag2.
    lib["util"]["circularize"](targetAltitude).
    print "Circularized".
    stage.
}
toggle ag3.
set warpmode to "physics".
set warp to 3.
until false {
    lib["util"]["do_orbitatelescope"]().
    lib["util"]["transmit_data"]().
    wait 5.
}
