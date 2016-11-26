
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
    export(lex(
      "ver", "0.0.1",
      "getHohmannDvOne", getHohmannDvOne@,
      "getHohmannDvTwo", getHohmannDvTwo@,
      "getTransferTime", getTransferTime@,
      "getCurrentPhaseAngle", getCurrentPhaseAngle@,
      "getRequiredPhaseAngle", getRequiredPhaseAngle@,
      "getBurnDuration", getBurnDuration@,
      "isIncEccentricity", isIncEccentricity@
    )).
}.
