toggle ag1.
set thrott to 1.0.
set dirvector to heading(90, 90).
lock throttle to thrott.
lock steering to dirvector.

copypath("0:/KSLib-master/library/lib_navball", "").
run lib_navball.
print "Dependencies loaded. Initializing...".

when ship:maxthrust < 0.1 then {
    if stage:number > 2  {
      stage.
      print "Staging...".
    }
    preserve.
}.
wait until ship:velocity:surface:mag > 100.

print "Initiating ascent profile...".
until ship:apoapsis >= 180000 {
    if pitch_for(ship) <= 45 {
        set dirvector to ship:prograde.
    } else {
        set tarangle to 90 - ship:velocity:surface:mag/19.
        set dirvector to heading(90, tarangle).
    }.
}.
print "Gravity turn complete.".
set thrott to -1.0.
