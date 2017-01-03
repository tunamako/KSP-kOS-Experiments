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
            throttleProfile is list(
                list(47500, 0.3),
                list(45000, 0.4),
                list(42500, 0.5),
                list(40000, 0.6),
                list(37500, 0.7),
                list(35000, 0.8),
                list(0, 1)
            ).
        if ship:velocity:surface:mag < 1 {
            lock throttle to 1.
            lock steering to heading(90,90).
            wait until alt:radar > 50.
        }
        print "Kickingggggg".
        local kickPitch is 90.
        lock truePrograde to R(0,0,0) * ship:velocity:surface.
        lock angleFromPrograde to vdot(ship:facing:forevector, truePrograde).
        lock progradePitch to 90 - vang(ship:up:forevector, truePrograde).
        until kickPitch < 87  {
            lock throttle to 1.
            lock steering to heading(pitchDirection, kickPitch).
            set kickPitch to kickPitch - 0.0030.
            wait 0.01.
        }.
        until angleFromPrograde > 0.99 {
            lock steering to heading(pitchDirection, progradePitch).
            wait 0.01.
        }.
        print "Kick complete! Hope it didnt hurt too much".
        until ship:orbit:apoapsis > targetAltitude {
            if angleFromPrograde > 0.99 {
                for entry in throttleProfile {
                    if alt:radar > entry[0] {
                        lock throttle to entry[1].
                        break.
                    }
                }
            } else {
                lock throttle to 0.
            }
            if alt:radar > 40000 {
                lock steering to heading(pitchDirection, 0).
            } else {
                lock steering to heading(pitchDirection, progradePitch).
            }
            wait 0.01.
        }.
        stage.
        rcs on.
        print "Target apoapsis reached, maintaining until out of atmosphere".
        until ship:altitude >= body:atm:height {
            lock steering to heading(pitchDirection, progradePitch).
            if(ship:orbit:apoapsis < targetAltitude) {
                lock throttle to 1.
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
