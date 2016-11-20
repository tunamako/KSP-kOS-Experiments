@lazyglobal off.
clearscreen.
set ship:control:pilotmainthrottle to 0.
if(ship:periapsis < 70000){
    if reachLKO(15) {
        print "woooooooooooooooooooooooooooooo".
    } else {
        clearscreen.
        print "Somebody fucked up".
    }
}
set target to body("Mun").
local r1 is ship:orbit:semimajoraxis.
local r2 is target:orbit:semimajoraxis.

function getHohmannDv {
    return sqrt(body:mu/r1) * (sqrt(2 * r2 / (r1 + r2)) - 1).
}
function getTransferTime {
    return constant:pi * sqrt((r1 + r2)^3 / (8 * body:mu)).
}
function getCurrentPhaseAngle {
    return vang(ship:body:position - ship:position, target:body:position - target:position).
}
function getRequiredPhaseAngle {
    return (1 - (1/(2 * sqrt(2))) * sqrt((r1/r2)+1)^3) * 180.
}

// 1) wait until currentphaseangle = requiredphaseangle
local phaseAngle is getCurrentPhaseAngle().
local requiredAngle is getRequiredPhaseAngle().
until abs(phaseAngle - requiredAngle) <= 1 {
    set phaseAngle to getCurrentPhaseAngle().
    clearscreen.
    print "Phase Angle1: " + phaseAngle.
    print "Required Phase Angle: " + requiredAngle.
    wait 0.01.
}
// 2) burn until ship:orbit:orbitalvelocity >= initial orbital velocity + hohmannDv
// 3) calculate and execute burn to enter munar orbit

lock throttle to 0.
wait until false.
