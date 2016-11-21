function reachStableOrbit {
    parameter
        stageHandler,
        targetAltitude.

    lock throttle to 0.0.
    print "Circularizing orbit.".
    print "Waiting for apopasis.".
    wait until eta:apoapsis < 15.
    until ship:periapsis > targetAltitude or (ship:apoapsis - ship:periapsis < 1500
            and ship:periapsis > 70000) {
        lock steering to ship:prograde + R(0,1,0).
        set targetApoETA to 30 * ship:orbit:eccentricity.

        if ship:maxthrust < 0.1 {
            stageHandler().
        } else if (eta:apoapsis < targetApoETA and eta:apoapsis < eta:periapsis)
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
    print "Stable orbit reached. Happy flying!".
    return ship:apoapsis - ship:periapsis < targetAltitude/10.
}

function launchGravTurn {
    parameter
        turnCoefficient,
        stageHandler,
        targetAltitude.

    lock throttle to 1.
    lock steering to heading(90, 90).
    wait 5.
    stage.
    print "Reaching kick altitude".
    wait until ship:velocity:surface:mag > 150.
    until ship:apoapsis >= targetAltitude {
        clearscreen.
        print "Tilting your ship!".
        if ship:maxthrust < 0.1 {
            stageHandler().
        }
        if pitch_for(ship) <= 45 {
            print "Pushing prograde.".
            lock steering to ship:prograde.
        } else {
            set tarPitch to 90 - ship:velocity:surface:mag/turnCoefficient.
            lock steering to heading(90, tarPitch).
            print "targetPitch: " + tarPitch.
        }.
        wait 0.01.
    }.
    clearscreen.
    print "Gravity turn complete.".
    return true.
}

function reachLKO {
    parameter
        turnCoefficient is 20, //Generally a value between 15 and 25. The higher this is, the slower the craft will turn.
        stageHandler is {      //A function to define staging behavior when maxthrust reaches 0.1 or lower.
          lock throttle to 0. wait 1.
          stage.
          lock throttle to 1.
        },
        targetAltitude is 75000.

  //return true if the gravturn and circularization were successful
    return launchGravTurn(turnCoefficient, stageHandler, targetAltitude)
            and reachStableOrbit(stageHandler, targetAltitude).
}
