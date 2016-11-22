clearscreen.
set ship:control:pilotmainthrottle to 0.

print "Success!".
until ship:periapsis < 0 or ship:maxthrust < 0.1 {
    lock steering to heading(270, 0).
    lock throttle to 1.
}
lock throttle to 0.
lock steering to ship:retrograde.
wait 3.
stage.
wait until alt:radar < 10000.
toggle ag3.
wait 1.
stage.
wait until alt:radar < 3000.
stage.

lock throttle to 0.
wait until false.
