
{
    local getHohmannDvOne is  {
        return sqrt(body:mu/ship:orbit:semimajoraxis) * (sqrt(2 * target:orbit:semimajoraxis / (ship:orbit:semimajoraxis + target:orbit:semimajoraxis)) - 1).
    }.
    local getHohmannDvTwo is  {
        set r1 to ship:orbit:periapsis + body:radius.
        set r2 to ship:orbit:apoapsis + body:radius.

        return sqrt(body:mu/r2) * (1 - sqrt(2 * r1 / (r1 + r2))).
    }.
    local getTransferTime is {
        return constant:pi * sqrt((ship:orbit:semimajoraxis + target:orbit:semimajoraxis)^3 / (8 * body:mu)).
    }.
    local getCurrentPhaseAngle is {
        return 360 - mod(ship:longitude - target:longitude  + 360, 360).
    }.
    local getRequiredPhaseAngle is {
        return (1 - (1/(2 * sqrt(2))) * sqrt((ship:orbit:semimajoraxis/target:orbit:semimajoraxis)+1)^3) * 180.
    }.
    local getBurnDuration is {
        parameter dv.
        list engines in en.
        local f is 0.
        local p is 0.
        for engine in en {
            if engine:ignition {
                set f to f + engine:maxthrust * 1000.
                set p to p + engine:isp.
            }
        }
        local m is ship:mass * 1000.
        local e is constant:e.
        local g is (constant:g * body:mass * ship:mass) / (ship:altitude + body:radius).

        return g * m * p * (1-e^(-dv/(g*p))) / f.
    }.
    local isIncEccentricity is {
        local prevEcc is ship:orbit:eccentricity.
        wait 0.5.
        return ship:orbit:eccentricity - prevEcc > 0.
    }.
    local getStageDv is {
        local fuels is list("LiquidFuel", "Oxidizer", "SolidFuel", "MonoPropellant").
        local fuelsDensity is list(0.005, 0.005, 0.0075, 0.004).
        local fuelMass is 0.

        // calculate total fuel mass
        for resource in stage:resources{
            local iteration is 0.
            for fuel in fuels {
                if fuel = resource:name {
                    set fuelMass to fuelMass + fuelsDensity[iter] * resource:amount.
                }.
                set iteration to iteration + 1.
            }.
        }.

        // thrust weighted average isp
        local thrustTotal is 0.
        local mDotTotal is 0.
        list engines in engList.
        for eng in engList {
            if eng:ignition {
                local t is eng:maxthrust * eng:thrustlimit/100.
                set thrustTotal TO thrustTotal + t.
                if eng:isP = 0 {
                    set mDotTotal TO 1.
                } else {
                    set mDotTotal TO mDotTotal + t / eng:isP.
                }
            }.
        }.
        if mDotTotal = 0 local avgIsp is 0.
        else local avgIsp is thrustTotal/mDotTotal.

        // deltaV calculation as Isp*g0*ln(m0/m1).
        return avgIsp * 9.81 * ln(ship:mass / (ship:mass - fuelMass)).
    }.
    export(lex(
      "ver", "0.0.1",
      "getHohmannDvOne", getHohmannDvOne@,
      "getHohmannDvTwo", getHohmannDvTwo@,
      "getTransferTime", getTransferTime@,
      "getCurrentPhaseAngle", getCurrentPhaseAngle@,
      "getRequiredPhaseAngle", getRequiredPhaseAngle@,
      "getBurnDuration", getBurnDuration@,
      "isIncEccentricity", isIncEccentricity@,
      "getStageDv", getStageDv@
    )).
}.
