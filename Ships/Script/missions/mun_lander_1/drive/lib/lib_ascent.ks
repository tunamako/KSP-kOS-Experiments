{
    local countdown is {
        parameter duration is 5.
        until duration = 0 {
          print "T - " + duration.
          wait 1.
          set duration to duration - 1.
        }
        print "Liftoff!".
    }.

    local ascend is {
        parameter
            pitchDirection is 90,
            targetAltitude is 70000,
            stageHandler is {
                if ship:maxthrust < 0.1 {
                    stage.
                    set initialTWR to ship:availablethrust / (ship:mass * (body:mu / body:radius^2)).
                    set initialPitch to 90 - vang(ship:up:vector, ship:facing:forevector).
                }
            }.
        local initialTWR is ship:availablethrust / (ship:mass * (body:mu / body:radius^2)).
        local initialPitch is 90.

        function targetPitch {
            set twr to ship:availablethrust / (ship:mass * (body:mu / body:radius^2)).
            set maxTWR to ship:availablethrust / (ship:drymass * (body:mu / body:radius^2)).
            return (initialPitch/max(abs((initialTWR - maxTWR)^4), 0.1)) * abs((twr-maxTWR)^4).
        }

        function targetThrottle {
            if ship:maxthrust < 0.1 {
                return 0.
            } else {
                return min(1, 2 * ((constant:g * body:mass * ship:mass) / (ship:altitude + body:radius)) / ship:maxthrust).
            }
        }
        if ship:velocity:surface:mag < 1 {
            lock throttle to targetThrottle().
            lock steering to heading(pitchDirection,90).
            wait until alt:radar > 50.
        }
        until ship:orbit:apoapsis > targetAltitude {
            if ship:altitude > 40000 {
                set pitch to 0.
            } else {
                set pitch to targetPitch().
            }
            set angleFromPrograde to vdot(facing:forevector, heading(pitchDirection, pitch):forevector).
            if angleFromPrograde > 0.8 {
                lock throttle to targetThrottle().
            } else {
                lock throttle to 0.
            }
            stageHandler().
            lock steering to heading(pitchDirection, pitch).
            clearscreen.
            print "Target Pitch: " + pitch.
            wait 0.01.
        }
        clearscreen.
        print "Target apoapsis reached, maintaining until out of atmosphere".
        until ship:altitude >= body:atm:height {
            stageHandler().
            lock steering to ship:prograde.
            if(ship:orbit:apoapsis < targetAltitude) {
                lock throttle to targetThrottle().
            } else {
                lock throttle to 0.
            }
            wait 0.01.
        }
    }.
    export(lex(
      "ver", "0.0.1",
      "countdown", countdown@,
      "ascend", ascend@
    )).
}
