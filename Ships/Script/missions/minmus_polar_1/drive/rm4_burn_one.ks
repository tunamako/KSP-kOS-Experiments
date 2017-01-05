clearscreen.
print "Exectuing first Hohmann burn".
local burnDv is hoh["getHohmannDvOne"]().
local currentDv is hoh["getStageDv"]().
local finalDv is initialDv - burnDv.

until hoh["getStageDv"]() <= finalDv {
    set angleFromBurnVector to vdot(ship:facing:forevector, heading(90,0):forevector).
    lock steering to heading(90, 0).

    if angleFromBurnVector >= 0.99 {
        lock throttle to min(1, max(0.01, 20 * ship:orbit:eccentricity)).
    } else {
        lock throttle to 0.
    }

    wait 0.01.
}
lock throttle to 0.
rm["set"]("rm5_calc_mun_correction").
reboot.
