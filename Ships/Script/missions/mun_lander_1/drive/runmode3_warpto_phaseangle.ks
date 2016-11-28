print "Waiting for required phase angle to transfer".

set target to body("Mun").
local burnDuration is hoh["getBurnDuration"](hoh["getHohmannDvOne"]()).
local phaseAngle is hoh["getCurrentPhaseAngle"]().
local requiredAngle is hoh["getRequiredPhaseAngle"]().
local angleGap is 0.
if phaseAngle < requiredAngle {
    set angleGap to 360 + phaseAngle - requiredAngle.
} else {
    set angleGap to phaseAngle - requiredAngle.
}
local burnETA is ((ship:orbit:period - target:orbit:period)/360) * angleGap + time:seconds.

set warpmode to "rails".
set warp to 3.

until burnETA - time:seconds <= burnDuration/2 {
    clearscreen.
    print "Phase Angle: " + hoh["getCurrentPhaseAngle"]().
    print "Required Phase Angle: " + requiredAngle.
    print "ETA: " + (burnETA - time:seconds).
    wait 0.01.
}
set warp to 0.

rm["set"]("runmode4_burn_one").
reboot.
