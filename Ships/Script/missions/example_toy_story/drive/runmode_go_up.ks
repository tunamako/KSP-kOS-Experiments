wait 5.
print char(34) + "Reach for the sky!" + char(34) + " - Woody".
lock steering to up.
stage.
wait until ship:maxthrust < 0.1.
stage.
unlock steering.
rm["set"]("runmode_do_tricks").
reboot.
