if defined lib = false {global lib is lexicon().}
if lib:haskey("util") = false {set lib["core"] to lexicon().}

set lib["util"]["ascent"] to {
    parameter
        targetAltitude is 70000,
        stageHandler is {      //A function to define staging behavior when maxthrust reaches 0.1 or lower.
            if ship:maxthrust < 0.1 {
                lock throttle to 0. wait 1.
                stage.
                lock throttle to 1.
            }
        }.
    function targetPitch {
        set twr to ship:availablethrust / (ship:mass * (body:mu / body:radius^2)).
        set maxTWR to ship:availablethrust / (ship:drymass * (body:mu / body:radius^2)).
        return (90/(initialTWR - maxTWR)^2) * (twr-maxTWR)^2.
    }
    function fuelEfficiency {

    }

    if alt:radar < 5 { //not the best way but will fix
        set initialTWR to ship:availablethrust / (ship:mass * (body:mu / body:radius^2)).
        lock throttle to 1.
        lock steering to heading(90,90).
        wait until alt:radar > 50.
    }

    until ship:altitude > 55000 {
        lock steering to heading(90, targetPitch()).
        set fuelEff to fuelEfficiency().
        if fuelEff < 80 {
            //set throttle as a function of fuel efficiency
        }
        wait 0.01.
    }

    until ship:apoapsis > targetAltitude {
        lock steering to heading(90, 0).
        lock throttle to 1.
        wait 0.01.
    }

    until ship:altitude >= body:atm:height {
        //set throttle as a function of ship:apoapsis - targetAltitude (maybe a PID?)
        wait 0.01.
    }

}
