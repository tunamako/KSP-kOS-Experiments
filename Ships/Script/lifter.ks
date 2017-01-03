@lazyglobal off.
set ship:control:pilotmainthrottle to 0.
rcs off.
lock throttle to 0.
lock steering_target to R(0,0,0) * ( (-1) * velocity:surface ).
lock steering to steering_target.


//coast to a certain longitude
wait until ship:longitude > -150 and ship:longitude < -149.

//one initial burst
local burst_time is 0.25 * (vang(ship:facing:forevector, (-1) * velocity:surface) / 180).
print "burst time: " + burst_time + " seconds.".
rcs on.
wait burst_time.
rcs off.

//wait until a slight overshoot
local facing_error is 0.
until facing_error > vang(ship:facing:forevector, (-1) * velocity:surface) {
  set facing_error to vang(ship:facing:forevector, (-1) * velocity:surface).
  wait 0.1.
}
rcs on.
wait until ship:longitude > -121 and ship:longitude < -120.//deorbit target is longitude:-121 to land at ksc (long 74; 195 degrees of travel)
rcs off.

print "initialize deorbit at longitude: " + ship:longitude.
lock throttle to 0.1.
wait until ship:orbit:periapsis < 50000.
unlock throttle.

wait until altitude < 72000.
rcs on.

wait until altitude < 70000.
print "Atmospheric entry at longitude: " + ship:longitude.
local parachuteModules is ship:modulesNamed("RealChuteModule").
for parachuteModule in parachuteModules {
  parachuteModule:doevent("Arm parachute").//tuned to deploy at correct altitudes
}

wait until ship:groundspeed < 100.
gear off. wait 1. gear on.//sometimes there's a bug where they start on.
print "Touchdown at longitude: " + ship:longitude.
rcs off.
unlock steering.
