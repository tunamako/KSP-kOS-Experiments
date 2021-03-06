{
    local circularize is {
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
        until eta:apoapsis < 15 {
            lock steering to ship:prograde.
        }
        until ship:orbit:periapsis > targetAltitude or
                (ship:orbit:apoapsis - ship:orbit:periapsis < 1500 and ship:orbit:periapsis > 70000) {
            set targetApoETA to 30 * ship:orbit:eccentricity.

            stageHandler().
            if (eta:apoapsis < targetApoETA and eta:apoapsis < eta:periapsis) {
                lock throttle to ship:orbit:eccentricity + 0.5.
                lock steering to ship:prograde.
            } else if eta:apoapsis > eta:periapsis {
                lock throttle to ship:orbit:eccentricity + 0.5.
                lock steering to heading(270, 0).
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
    export(lex(
      "ver", "0.0.1",
      "circularize", circularize@
    )).
}
