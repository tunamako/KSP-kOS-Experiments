toggle ag1.
clearscreen.
set ship:control:pilotmainthrottle to 0.

asc["countdown"]().
stage.
set warpmode to "physics".
set warp to 3.
asc["ascend"](90, 76000).
print "Ascent complete".
set warp to 0.
toggle ag2.
rm["set"]("runmode_circularize").
reboot.
