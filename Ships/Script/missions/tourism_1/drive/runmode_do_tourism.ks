clearscreen.
set ship:control:pilotmainthrottle to 0.
print "Waiting for tourism".

wait until time:seconds >= timeStart + timeToOrbit.

rm["set"]("runmode_deorbit").
reboot.
