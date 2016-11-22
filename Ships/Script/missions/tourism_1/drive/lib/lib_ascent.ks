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
                    lock throttle to 0. wait 1.
                    stage.
                    lock throttle to 1.
                }
            }.
        local initialTWR is ship:availablethrust / (ship:mass * (body:mu / body:radius^2)).

        function targetPitch {
            set twr to ship:availablethrust / (ship:mass * (body:mu / body:radius^2)).
            set maxTWR to ship:availablethrust / (ship:drymass * (body:mu / body:radius^2)).
            return (90/(initialTWR - maxTWR)^2) * (twr-maxTWR)^2.
        }
        function targetThrottle {
            return false.
        }

        if ship:velocity:surface:mag < 1 {
            lock throttle to 1.
            lock steering to heading(pitchDirection,90).
            wait until alt:radar > 50.
        }

        until ship:altitude > 55000 or ship:orbit:apoapsis > targetAltitude {
            stageHandler().
            lock steering to heading(pitchDirection, targetPitch()).
            wait 0.01.
        }

        until ship:apoapsis > targetAltitude {
            stageHandler().
            lock steering to heading(pitchDirection, 0).
            lock throttle to 1.
            wait 0.01.
        }

        until ship:altitude >= body:atm:height {
            stageHandler().
            if(ship:orbit:apoapsis < targetAltitude) {
                lock throttle to 0.5.
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
