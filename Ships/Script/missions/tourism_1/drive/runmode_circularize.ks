clearscreen.
set ship:control:pilotmainthrottle to 0.
circ["circularize"](76000).
print "Circularized".
set timeStart to time:seconds.
rm["set"]("runmode_do_tourism").
reboot.
