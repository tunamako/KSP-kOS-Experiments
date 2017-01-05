clearscreen.
set ship:control:pilotmainthrottle to 0.

circ["circularize"](90, 80000).
print "Circularized".

rm["set"]("rm3_warpto_phaseangle").
reboot.
