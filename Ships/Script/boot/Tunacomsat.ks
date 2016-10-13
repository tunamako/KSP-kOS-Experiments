set thrott to 1.
set dirvector to heading(90, 90).

lock throttle to thrott.
lock steering to dirvector.

when ship:maxthrust < 0.1 then {
    if STAGE:NUMBER = 1 {
        wait until ship:velocity:surface:MAG < 800.
    }.
    print "Staging...".
    stage.
    preserve.
}.
wait until ship:velocity:surface:mag > 100.

print "Initiating ascent profile...".
until ship:apoapsis > 180000 {
    if ship:velocity:surface:mag >= 700 {
        sas on.
        set dirvector to ship:prograde.
    } else {
        set tarangle to 90 - ship:velocity:surface:mag/15.
        set dirvector to heading(90, tarangle).
    }.
}.

print "Gravity turn complete.".
function moveToapoapsis {
    print "Moving to apoapsis...".
    set thrott to -1.0.
    wait until ship:apoapsis - ship:altitude < 1000.
    set thrott to 1.0.
    print "Move complete. Adjusting orbit...".
}
moveToapoapsis().

until ship:periapsis >= 1200000 {
    if ship:apoapsis - ship:altitude > 10000{
        moveToapoapsis().
    }.
    set DIRVECTOR to ship:prograde.
}
print "Stable orbit achieved. Shutting down.".
set thrott to -1.0.
