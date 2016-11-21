print char(34) + "This isn't flying; It's falling... with style!" + char(34) + " - Buzz Lightyear".

wait until ship:verticalspeed < 30.
set ship:control:pitch to 1.
wait until ship:verticalspeed < -30.
set ship:control:pitch to 0.
rm["set"]("runmode_dont_die").
reboot.
