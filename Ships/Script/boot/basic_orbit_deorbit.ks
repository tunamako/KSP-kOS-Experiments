@lazyglobal off.
clearscreen.
set ship:control:pilotmainthrottle to 0.

copypath("0:/libs/tuna/lib_lko", "").
run lib_lko.
copypath("0:/libs/KSLib-master/library/lib_navball", "").
run lib_navball.
print "Dependencies loaded.".

if reachLKO(19) {
  print "Success!".
  deletepath("1:/lib_navball").
  deletepath("1:/lib_lko").
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
