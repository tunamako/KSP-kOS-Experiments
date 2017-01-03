{
    local circularize is {
        parameter
            pitchDirection is 90,
            targetAltitude is 70000.

        lock throttle to 0.
        local dV is hoh["getHohmannDvTwo"]().
        local burnDuration is hoh["getBurnDuration"](dV).
        print "dV: " + dV.
        print "waiting for apoapsis".
        until eta:apoapsis < burnDuration/2 {
            lock steering to heading(pitchDirection,0).
            wait 0.01.
        }

        print "initiating burn".
        local prevEcc is ship:orbit:eccentricity.
        until ship:orbit:periapsis > targetAltitude {
            set angleFromBurnVector to vdot(ship:facing:forevector, heading(pitchDirection,0):forevector).
            lock steering to heading(pitchDirection,0).

            if ship:orbit:eccentricity > prevEcc {
                print "eccentricity increasing".
                break.
            } else if angleFromBurnVector >= 0.99 {
                lock throttle to min(1, max(0.01, 20 * ship:orbit:eccentricity)).
            } else {
                lock throttle to 0.
            }
            set prevEcc to ship:orbit:eccentricity.
            wait 0.5.
        }
        lock throttle to 0.
    }.
    export(lex(
      "ver", "0.0.1",
      "circularize", circularize@
    )).
}
