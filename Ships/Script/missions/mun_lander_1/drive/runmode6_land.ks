function suicideBurnAlt {
    local gravAcc is (body:mu * ship:mass) / (ship:altitude + body:radius)^2.
    local shipAcc is ship:availablethrust/ship:mass.
    local deltaV is sqrt((2 * gravAcc * alt:radar) + ship:verticalSpeed^2).

    return (deltaV^2) / (2 * shipAcc).
}.

until alt:radar < suicideBurnAlt() {
    print "Current Alt: " + alt:radar.
    print "Suicide Alt: " + suicideBurnAlt().
    lock steering to retrograde.
}
until ship:status = "landed" {
    lock throttle to 1.
    lock steering to retrograde.
}

wait until false.
reboot.
