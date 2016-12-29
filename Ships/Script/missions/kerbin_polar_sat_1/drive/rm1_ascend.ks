toggle ag1.
clearscreen.
set ship:control:pilotmainthrottle to 0.

asc["countdown"]().
stage.
set warpmode to "physics".
set warp to 2.
asc["ascend"](-5, 2000000).
print "Ascent complete".
set warp to 0.
stage.
wait 2.
toggle ag2.
stage.
rm["set"]("rm2_circ").
reboot.
