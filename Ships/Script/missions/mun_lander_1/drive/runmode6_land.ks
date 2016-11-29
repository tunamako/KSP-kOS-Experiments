//function suicideBurnAlt {
//    local gravAcc is body:mu / (body:radius)^2.
//    local shipAcc is ship:availablethrust/ship:mass.
//    local deltaV is sqrt((2 * gravAcc * alt:radar) + ship:verticalSpeed^2).
//
//    return (deltaV^2) / (2 * shipAcc).
//}.

function suicideBurnAlt {
	parameter safety. //1 corresponds to no safety margin, 1.1 has a 10% safety margin

	local gravAcc is -(body:mu * ship:altitude) / (ship:altitude + body:radius)^2.
	local suicideAlt to (ship:verticalspeed^2)/(2*((thrust/ship:mass) + gravAcc)).
	return safety * suicideAlt. //adds the safety margin for error
}.

until alt:radar < suicideBurnAlt(1.1) {
    print "Current Alt: " + alt:radar.
    print "Suicide Alt: " + suicideBurnAlt(1.1).
    lock steering to retrograde.
}
until ship:status = "landed" {
    lock throttle to 1.
    lock steering to retrograde.
}

wait until false.
reboot.
