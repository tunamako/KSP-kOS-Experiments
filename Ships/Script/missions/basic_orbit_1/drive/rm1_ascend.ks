toggle ag1.
clearscreen.
set ship:control:pilotmainthrottle to 0.

asc["countdown"]().
stage.
asc["ascend"](90, 80000).
print "Ascent complete".
wait 2.
toggle ag2.
rm["set"]("rm2_circ").
reboot.
