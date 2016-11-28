clearscreen.
print "Warping to the Mun".

set warpmode to "rails".
until ship:body:name = "Mun" {
    set warp to 5.
}
set warp to 0.

rm["set"]("runmode6_land").
reboot.
