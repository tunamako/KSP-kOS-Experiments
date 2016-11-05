toggle ag1.
set thrott to 1.
set dirvector to heading(90, 90).
lock throttle to thrott.
lock steering to dirvector.

copypath("0:/KSLib-master/library/lib_navball", "").
run lib_navball.
print "Dependencies loaded. Initializing...".

when ship:maxthrust < 0.1 then {
    if stage:number > 3  {
      stage.
      print "Staging...".
    }
    preserve.
}.
wait until ship:velocity:surface:mag > 100.

print "Initiating ascent profile...".
until ship:apoapsis >= 90000 {
    if pitch_for(ship) <= 45 {
        set dirvector to ship:prograde.
    } else {
        set tarangle to 90 - ship:velocity:surface:mag/19.
        set dirvector to heading(90, tarangle).
    }.
}.
print "Gravity turn complete.".

function moveToPeriapsis {
    print "Moving to periapsis...".
    set thrott to -1.0.
    set dirvector to ship:retrograde.
    wait until ship:altitude - ship:periapsis < 20.
    set thrott to 1.0.
    print "Move complete. Adjusting orbit...".
}
function moveToApoapsis {
    print "Moving to apoapsis...".
    set thrott to -1.0.
    set dirvector to ship:prograde.
    wait until ship:apoapsis - ship:altitude < 20.
    set thrott to 1.0.
    print "Move complete. Adjusting orbit...".
}
function circularize {
  until ship:apoapsis - ship:periapsis < 1500  {
      if ship:apoapsis >= targetAlt + 10000 {
          if ship:altitude - ship:periapsis > 250 {
            moveToPeriapsis().
          }
          set dirvector to ship:retrograde.
      }else if ship:apoapsis - ship:altitude > 250{
          moveToApoapsis().
      } else {
          set dirvector to ship:prograde.
      }.
  }
}
function getPeriod {
  parameter
    apoapsis,
    periapsis.
    set semimajoraxis to (apoapsis + periapsis + 1200000)/2.
    return (
      2*constant:pi*sqrt(((semimajoraxis)^3)/3531642300000)
    ).
}

moveToApoapsis().
until ship:apoapsis >=800000 {
  set dirvector to ship:prograde.
}
set thrott to -1.0.
set targetAlt to ship:apoapsis.
set targetPeriod to getPeriod(ship:apoapsis, ship:apoapsis).
set targetTransferPeriod to 2/3 * targetPeriod.
set targetTransferPerigee to 2 * ((3531642300000*targetTransferPeriod^2)/4*(constant:pi)^2)^(1/3) - ship:apoapsis - 1200000.
print "Target Period: " + targetPeriod.
print "Target Transfer Period: " + targetTransferPeriod.
print "Target Transfer Perigee: " + targetTransferPerigee.
moveToApoapsis().
set thrott to 1.0.
until ship:periapsis >= targetTransferPerigee {
  set dirvector to ship:prograde.
}
set thrott to -1.0.
