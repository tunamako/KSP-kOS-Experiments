@lazyglobal off.
clearscreen.
set ship:control:pilotmainthrottle to 0.

if reachLKO(19) {
  print "Success!".
  stage.
  until ship:periapsis < 0 or ship:maxthrust < 0.1 {
    lock steering to heading(270, 0).
    lock throttle to 1.
  }
  lock throttle to 0.
  lock steering to ship:prograde.
  wait until ship:altitude < 3000.
  stage.
} else {
  clearscreen.
  print "Somebody fucked up".
}

lock throttle to 0.
wait until false.
