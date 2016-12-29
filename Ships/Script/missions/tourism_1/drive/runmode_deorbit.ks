clearscreen.
set ship:control:pilotmainthrottle to 0.

print "Success!".
until ship:periapsis < 0  {
    lock steering to heading(270, 0).
    lock throttle to 1.
}
lock throttle to 0.
lock steering to ship:retrograde.
wait 3.
stage.
until ship:altitude < 70000 {
    set warpmode to "rails".
    set warp to 3.
}
set warpmode to "physics".
set warp to 3.

wait until alt:radar < 3000.
toggle ag3.
wait 2.
until ship:velocity:surface:mag < 10 {
    stage.
    wait 0.1.
}


lock throttle to 0.
wait until false.
