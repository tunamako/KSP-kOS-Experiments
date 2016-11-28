
{
    local getHohmannDv is  {
        return sqrt(body:mu/ship:orbit:semimajoraxis) * (sqrt(2 * target:orbit:semimajoraxis / (ship:orbit:semimajoraxis + target:orbit:semimajoraxis)) - 1).
    }.
    local getTransferTime is {
        return constant:pi * sqrt((ship:orbit:semimajoraxis + target:orbit:semimajoraxis)^3 / (8 * body:mu)).
    }.
    local getCurrentPhaseAngle is {
        return vang(ship:body:position - ship:position, target:body:position - target:position).
    }.
    local getRequiredPhaseAngle is {
        return (1 - (1/(2 * sqrt(2))) * sqrt((ship:orbit:semimajoraxis/target:orbit:semimajoraxis)+1)^3) * 180.
    }.
    local getBurnDuration is {
        parameter dv.
        list engines in en.
        local f is en[0]:maxthrust * 1000.
        local m is ship:mass * 1000.
        local e is constant:e.
        local p is en[0]:isp.
        local g is (constant:g * body:mass * ship:mass) / (ship:altitude + body:radius).

        return g * m * p * (1-e^(-dv/(g*p))) / f.
    }.
    export(lex(
      "ver", "0.0.1",
      "getHohmannDv", getHohmannDv@
      "getTransferTime", getTransferTime@
      "getCurrentPhaseAngle", getCurrentPhaseAngle@
      "getRequiredPhaseAngle", getRequiredPhaseAngle@
      "getBurnDuration", getBurnDuration@
    )).
}.
