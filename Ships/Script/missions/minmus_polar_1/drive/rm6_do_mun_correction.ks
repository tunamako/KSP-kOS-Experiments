local nd is nextnode.
print "Node in: " + round(nd:eta) + ", DeltaV: " + round(nd:deltav:mag).
local max_acc is ship:maxthrust/ship:mass.
local burn_duration is nd:deltav:mag/max_acc.
print "Crude Estimated burn duration: " + round(burn_duration) + "s".

lock throttle to 0.
local dV is nd:deltav.
local burnDuration is hoh["getBurnDuration"](dV).
print "dV: " + dV.
print "waiting for burn time".
until nd:eta < burnDuration/2 {
    lock steering to nd:burnvector
    wait 0.01.
}

print "initiating burn".
until ship:orbit:periapsis > targetAltitude {
    set angleFromBurnVector to vdot(ship:facing:forevector, nd:burnvector).
    lock steering to nd:burnvector.

    if angleFromBurnVector >= 0.99 {
        lock throttle to min(1, max(0.01, 20 * ship:orbit:eccentricity)).
    } else {
        lock throttle to 0.
    }
    wait 0.1.
}
lock throttle to 0.
rm["set"]("rm7_capture_orbit").
