toggle ag1.
set thrott to 1.
set dirvector to heading(90, 90).
set targetAlt to 130000.
lock throttle to thrott.
lock steering to dirvector.

copypath("0:/KSLib-master/library/lib_navball", "").
run lib_navball.
print "Dependencies loaded. Initializing...".

when ship:maxthrust < 0.1 then {
    if stage:number > 0  {
      stage.
      print "Staging...".
    }
    preserve.
}.
wait until ship:velocity:surface:mag > 100.

print "Initiating ascent profile...".
until ship:apoapsis >= targetAlt {
    if pitch_for(ship) <= 45 {
        set dirvector to ship:prograde.
    } else {
        set tarangle to 90 - ship:velocity:surface:mag/19.
        set dirvector to heading(90, tarangle).
    }.
}.
print "Gravity turn complete.".

function moveToApoapsis {
    print "Moving to apoapsis...".
    set thrott to -1.0.
    set dirvector to ship:prograde.
    wait until ship:apoapsis - ship:altitude < 20.
    set thrott to 1.0.
    print "Move complete. Adjusting orbit...".
}
moveToApoapsis().

until ship:periapsis > 70000 {
  set dirvector to ship:prograde.
}

until ship:apoapsis - ship:periapsis < 1500  {
    if ship:apoapsis - ship:altitude > 700 {
        moveToApoapsis().
    } else {
        set dirvector to ship:prograde.
    }.
}.
print "Stable orbit achieved. Shutting down.".
set thrott to -1.0.
