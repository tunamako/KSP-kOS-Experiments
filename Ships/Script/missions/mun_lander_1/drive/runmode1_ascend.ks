toggle ag1.
clearscreen.
set ship:control:pilotmainthrottle to 0.

asc["countdown"]().
stage.

set warpmode to "physics".
set warp to 2.

asc["ascend"](90, 80000).
print "Ascent complete".

toggle ag2.
set warp to 0.

rm["set"]("runmode2_circ").
reboot.
