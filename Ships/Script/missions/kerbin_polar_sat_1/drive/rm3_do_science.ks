clearscreen.
set ship:control:pilotmainthrottle to 0.

until false {
    sci["do_experiments"]().
    sci["do_dmagic"](list("rpwsAnt","dmImagingPlatform")).
    sci["transmit_data"]().
    wait 5.
}
