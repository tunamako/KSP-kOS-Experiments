if defined lib = false {global lib is lexicon().}
if lib:haskey("util") = false {set lib["util"] to lexicon().}
set ship:control:pilotmainthrottle to 0.

set lib["util"]["circularize"] to {
    parameter
        targetAltitude is 70000,
        stageHandler is {
            if ship:maxthrust < 0.1 {
                lock throttle to 0. wait 1.
                stage.
                lock throttle to 1.
            }
        }.

    lock throttle to 0.0.
    print "Circularizing orbit.".
    print "Waiting for apopasis.".
    wait until eta:apoapsis < 15.
    until ship:orbit:periapsis > targetAltitude or
            (ship:orbit:apoapsis - ship:orbit:periapsis < 1500 and ship:orbit:periapsis > 70000) {
        lock steering to ship:prograde.
        set targetApoETA to 30 * ship:orbit:eccentricity.

        stageHandler().
        if (eta:apoapsis < targetApoETA and eta:apoapsis < eta:periapsis)
            or eta:apoapsis > eta:periapsis  {
            lock throttle to ship:orbit:eccentricity + 0.5.
        } else {
            lock throttle to 0.
        }

        clearscreen.
        print "Apoapsis: " + ship:orbit:apoapsis.
        print "Periapsis: " + ship:orbit:periapsis.
        print "Eccentricity: " + ship:orbit:eccentricity.
        print "Target ApoapsisETA: " + targetApoETA.
        wait 0.01.
    }

    clearscreen.
    print "Stable orbit reached".
    lock throttle to 0.
}.
