function wah{
    if(ship:periapsis < 70000){
        if reachLKO(19) {
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
    print "HohmannDv: " + getHohmannDv().
    print "Transfer Time: " + getTransferTime().
    print "Phase Angle: " + getCurrentPhaseAngle().
    print "Required Phase Angle: " + getRequiredPhaseAngle().

    until abs(target:orbit:inclination - ship:orbit:inclination) < 1 {

    }
    // 1) equalize orbital inclination
    // 2) wait until currentphaseangle = requiredphaseangle
    // 3) burn until ship:orbit:orbitalvelocity >= initial orbital velocity + hohmannDv
    // 4) calculate and execute burn to enter munar orbit

    lock throttle to 0.
    wait until false.
}
