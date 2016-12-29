clearscreen.
set ship:control:pilotmainthrottle to 0.
print "Waiting for tourism".
if stage:number = 3 {
    stage.
}
set warpmode to "rails".
set warp to 3.
wait until time:seconds >= timeStart + timeToOrbit.
set warp to 0.
rm["set"]("runmode_deorbit").
reboot.
