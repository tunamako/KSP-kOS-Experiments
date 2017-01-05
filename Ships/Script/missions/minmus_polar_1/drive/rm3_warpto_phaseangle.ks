print "Waiting for required phase angle to transfer".

set target to body("Mun").
local burnDuration is hoh["getBurnDuration"](hoh["getHohmannDvOne"]()).
local burnArcLength is (burnDuration/ship:orbit:period) * 360.
local requiredAngle is hoh["getRequiredPhaseAngle"]().

function angleGap {
    local phaseAngle is hoh["getCurrentPhaseAngle"]().
    if phaseAngle < requiredAngle {
        return 360 + phaseAngle - requiredAngle.
    } else {
        return phaseAngle - requiredAngle.
    }
}

set warpmode to "rails".
set warp to 3.

until angleGap() <= burnArcLength/2 {
    lock steering to heading(90, 0).
    clearscreen.
    print "Phase Angle: " + hoh["getCurrentPhaseAngle"]().
    print "Required Phase Angle: " + requiredAngle.
    print "burnDuration: " + burnDuration.
    print "angleGap: " + angleGap().
    wait 0.01.
}
set warp to 0.

rm["set"]("rm4_burn_one").
reboot.
