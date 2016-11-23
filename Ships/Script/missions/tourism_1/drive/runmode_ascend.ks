toggle ag1.
clearscreen.
set ship:control:pilotmainthrottle to 0.

asc["countdown"]().
stage.
asc["ascend"](90, 76000).
print "Ascent complete".
rm["set"]("runmode_circularize").
toggle ag2.

reboot.
