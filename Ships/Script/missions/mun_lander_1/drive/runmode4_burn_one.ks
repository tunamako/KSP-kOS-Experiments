
until ship:orbit:apoapsis >= target:orbit:apoapsis {
    lock steering to heading(90, 0).
    lock throttle to 5 / ship:orbit:eccentricity.
    wait 0.01.
}
lock throttle to 0.
rm["set"]("runmode5_warpto_mun").
reboot.
