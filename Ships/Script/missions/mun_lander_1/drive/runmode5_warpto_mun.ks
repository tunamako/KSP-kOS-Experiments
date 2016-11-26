set warpmode to "rails".
until not ship:orbit:hasnextpatch {
    set warp to 5.
}
set warp to 0.

rm["set"]("runmode6_deorbit").
reboot.
