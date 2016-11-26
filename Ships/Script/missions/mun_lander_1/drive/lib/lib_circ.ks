{
    local circularize is {
        parameter
            targetAltitude is 70000,
            stageHandler is {
                if ship:maxthrust < 0.1 {
                    stage.
                    lock throttle to 0.
                }
            }.

        lock throttle to 0.0.
        local deltaV is hoh["getHohmannDvTwo"]().
        local burnDuration is hoh["getBurnDuration"](deltaV).
        local circNode is node(time:seconds + eta:apoapsis, 0, 0, deltaV).
        add circNode.

        until circNode:eta < burnDuration/2 {
            lock steering to circNode:burnvector.
            clearscreen.
            print "Apoapsis: " + ship:orbit:apoapsis.
            print "Time to Apoapsis: " + eta:apoapsis.
            print "Periapsis: " + ship:orbit:periapsis.
            print "Eccentricity: " + ship:orbit:eccentricity.
            print "deltaV: " + deltaV.
            wait 0.01.
        }
        local burnEnd to time:seconds + burnDuration.

        until ship:orbit:eccentricity < 0.002 and ship:orbit:periapsis > 70000 {

            set nodeFacing to lookdirup(circNode:deltav, ship:facing:topvector).
            set angleFromNode to vdot(facing:forevector, nodeFacing:forevector).

            lock steering to circNode:burnvector.
            if (angleFromNode >= 0.99) and (not hoh["isIncEccentricity"]()) {
                lock throttle to 6 * sqrt(ship:orbit:eccentricity).
            } else {
                lock throttle to 0.
            }


            clearscreen.
            print "Apoapsis: " + ship:orbit:apoapsis.
            print "Periapsis: " + ship:orbit:periapsis.
            print "Eccentricity: " + ship:orbit:eccentricity.
            print "deltaV: " + deltaV.
            print  "Remaining burn time: " + (burnEnd - time:seconds).
            print "Angle From Burn Node: " + angleFromNode.
            wait 0.01.
        }
        remove circNode.
        print "Stable orbit reached".
        lock throttle to 0.
    }.
    export(lex(
      "ver", "0.0.1",
      "circularize", circularize@
    )).
}
