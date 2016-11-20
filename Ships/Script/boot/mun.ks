@lazyglobal off.
clearscreen.
set ship:control:pilotmainthrottle to 0.
if(ship:periapsis < 70000){
    copypath("0:/libs/tuna/lib_lko", "").
    run lib_lko.
    copypath("0:/libs/KSLib-master/library/lib_navball", "").
    run lib_navball.
    print "Dependencies loaded.".

    if reachLKO(19) {
        deletepath("1:/lib_navball").
        deletepath("1:/lib_lko").
    } else {
        clearscreen.
        print "Somebody fucked up".
    }
}
set target to body("Mun").
function burnTime {
    parameter dV.
    local en is lexicon().
    list engines in en.

    local f is en[0]:maxthrust * 1000.
    local m is ship:mass * 1000.
    local e is constant:e.
    local p is en[0]:isp.
    local g is 9.80665.

    return g * m * p * (1 - e^(-dV/(g*p))) / f.
}
local r1 is ship:orbit:semimajoraxis.
local r2 is target:orbit:semimajoraxis.
local phaseAngle is vang(ship:body:position - ship:position, target:body:position - target:position).
local requiredAngle is (1 - (1/(2 * sqrt(2))) * sqrt((r1/r2)+1)^3) * 180.
local burnETA is time:seconds + (phaseAngle - requiredAngle) / ((360 / ship:orbit:period) - (360 / target:orbit:period)).


//wait until burn time
local burnDuration is burnTime(sqrt(body:mu/r1) * (sqrt(2 * r2 / (r1 + r2)) - 1)).
until burnETA - time:seconds < (burnDuration/2) {
    lock steering to heading(90, 0).
    clearscreen.
    print "Waiting for appropriate phase angle".
    print "ETA: " + (burnETA - time:seconds - burnDuration/2).
    wait 0.01.
}

//execute first burn
until ship:orbit:hasnextpatch {
    clearscreen.
    print "Executing First Burn".
    lock steering to heading(90, 0).
    lock throttle to 1.
    wait 0.01.
}
lock throttle to 0.

//wait until next burn time
print "Waiting for mun encounter."
wait until ship:obt:body:name = "Mun".
print "Waiting for mun periapsis."
wait until eta:periapsis < 10.

//execute second burn
until ship:orbit:periapsis <= 50000 {
    clearscreen.
    print "Executing Second Burn".
    lock steering to retrograde.
    lock throttle to 1.
    wait 0.01.
}

//do science here
//wait for alt < 60000
//do science again
//wait until apoapsis
//burn prograde until munar escape
//rendevouz with kerbin

lock throttle to 0.

wait until false.
