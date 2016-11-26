
function accelGravity {
    return (constant:g * body:mass * ship:mass) / (ship:altitude + body:radius).
}

function forceThrust {
    local totalThrust to 0.
    list engines in engineList.
    for engine in engineList {
      set totalThrust to totalThrust + engine:thrust.
    }
    return totalThrust * ship:facing:vector:normalized.
}

function forceGravity {
    return accelGravity() * ship:up:inverse:vector:normalized.
}

function forceNet {
    set prevSpeed to ship:airspeed.
    wait 1.
    return ship:mass * (ship:airspeed - prevSpeed) * ship:prograde:vector:normalized.
}

function forceDrag {
    return forceNet() - forceThrust() - forceGravity().
}

function terminalSpeed {
    return sqrt((ship:velocity:surface:mag^2 * accelGravity())/forceDrag():mag).
}
