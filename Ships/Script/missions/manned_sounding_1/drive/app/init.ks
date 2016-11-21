clearscreen.
set ship:control:pilotmainthrottle to 0.

wait 5.
toggle ag1.
do_experiments().
do_magnetometer().
transmit_data().
wait 5.
toggle ag1.

wait 10.
lock steering to heading(90, 90).
lock throttle to 1.
stage.
print "Super Liftoff!".

//Low flying
wait 5.
do_experiments().
transmit_data().
//High Flying
wait until ship:altitude > 18500.
do_experiments().
transmit_data().
//Low Spess
wait until ship:orbit:apoapsis > 255000.
lock throttle to 0.
wait until ship:altitude > 75000.
toggle ag1.
wait 5.
toggle ag2.
wait 5.
do_experiments().
do_magnetometer().
transmit_data().
//High Spess
wait until ship:altitude > 250000.
do_experiments(list("sensorBarometer")).
do_magnetometer().
wait until addons:rt:haskscconnection(ship).
transmit_data().

toggle ag2.
wait 5.
toggle ag1.
lock steering to retrograde.
wait until alt:radar <= 100000.
until ship:maxthrust < 0.1 {lock throttle to 1.}.
lock throttle to 0.
stage.

wait until alt:radar <= 3000.
toggle ag1.
stage.

wait until ship:status = "landed" or ship:status = "splashed".
print "Payload has " + ship:status + ".".
do_experiments().
do_magnetometer().
