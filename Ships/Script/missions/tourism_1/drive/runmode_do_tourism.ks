clearscreen.
set ship:control:pilotmainthrottle to 0.
print "Waiting for tourism".

wait until time:seconds >= timeStart + 14400.

rm["set"]("runmode_deorbit").
reboot.
