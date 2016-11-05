@lazyglobal off.
clearscreen.
copypath("0:/stuco/lib/stuco_lib_pid.ks",""). run stuco_lib_pid.
copypath("0:/KSLib-master/library/lib_navball.ks",""). run lib_navball.
brakes on.
set ship:control:mainthrottle to 0.//when the program ends, the lock will (hopefully) release to this value.
wait 5.


function latlng_distance {
  parameter location.
  return (
    sqrt(
      (location:lat - ship:latitude)^2
    + (location:lng - ship:longitude)^2
    )
  ).
}

local pidAltitude is stuco_pid_init(
  -15, 15, 2,//target pitch
  stuco_component_init(0.05),//just a p controller keeps within 40-50m near sea level with no oscillation
  stuco_component_init(0.01, 0, 200)//resolves within a first overshoot capped at around 15m
).
local targetAltitude is 0.
local pidPitch is stuco_pid_init(
  -1, 1, 2,//raw pitch control
  stuco_component_init(0.02),//pretty dang quick
  stuco_component_init(0.01,0,20),//resolves within about five seconds
  stuco_component_init(0.002)//stable just past 100m/s low atmosphere. still kinda bouncy at 50m/s
).
local targetPitch is 0.
local pidRoll is stuco_pid_init(
  -1, 1, 2,//raw pitch control
  stuco_component_init(0.002),
  stuco_component_init(0),
  stuco_component_init(0.001)
).
local targetRoll is 0.
local scienceLocations is lexicon(
  //list( coordinates, altitude )
  "shores", list(latlng(-0.201601652617992, -74.7323365132676), 800),
  "grasslands", list(latlng(-0.306519822881281, -74.9757792051902), 800),
  "highlands", list(latlng(0.731651599454657,  -77.1692303994254), 800),
  "mountains", list(latlng(0.681255389768304,  -79.0715661536106), 2800),
  "desert-wp1", list(latlng(-4.05264342473283,  -80.1935000778729), 800),
  "desert", list(latlng(-1.07173620558408, -87.2123524106668), 800)
).


//takeoff and ascent
brakes off.
stage.
lock throttle to 1.
set targetAltitude to 1000.
until ship:altitude > 950 {
  set pidAltitude to stuco_pid_seek(pidAltitude, targetAltitude, ship:altitude).
  set targetPitch to pidAltitude["control"]["curr"].//start damping the controls as speed picks up.

  set pidPitch to stuco_pid_seek(pidPitch, targetPitch, pitch_for(ship)).
  set ship:control:pitch to pidPitch["control"]["curr"] * min(1, 50 / ship:airspeed).//start damping the controls as speed picks up.

  set pidRoll to stuco_pid_seek(pidRoll, targetRoll, roll_for(ship)).
  set ship:control:roll to pidRoll["control"]["curr"] * min(1, 50 / ship:airspeed).
  clearscreen.
  print "takeoff, climb to near 1000m.".
  wait 0.01.
}
gear off.
lock throttle to 0.7.

until latlng_distance(scienceLocations["desert-wp1"][0]) < 0.05 {
  set pidAltitude to stuco_pid_seek(pidAltitude, scienceLocations["desert-wp1"][1], alt:radar).
  set targetPitch to pidAltitude["control"]["curr"].//start damping the controls as speed picks up.

  set pidPitch to stuco_pid_seek(pidPitch, targetPitch, pitch_for(ship)).
  set ship:control:pitch to pidPitch["control"]["curr"] * min(1, 50 / ship:airspeed).//start damping the controls as speed picks up.

  if scienceLocations["desert-wp1"][0]:bearing < 1 and scienceLocations["desert-wp1"][0]:bearing > -1 {
    set targetRoll to 0.
  } else {
    set targetRoll to
      2 * min(
        25,
        max(
          -25,
          scienceLocations["desert-wp1"][0]:bearing
        )
      ).
  }
  set pidRoll to stuco_pid_seek(pidRoll, targetRoll, roll_for(ship)).
  set ship:control:roll to pidRoll["control"]["curr"] * min(1, 50 / ship:airspeed).
  clearscreen.
  print "bearing to next location: " + scienceLocations["desert-wp1"][0]:bearing.
  print "distance to location: " + latlng_distance(scienceLocations["desert-wp1"][0]).
  wait 0.01.
}
until latlng_distance(scienceLocations["desert"][0]) < 0.05 {
  set pidAltitude to stuco_pid_seek(pidAltitude, scienceLocations["desert"][1], alt:radar).
  set targetPitch to pidAltitude["control"]["curr"].//start damping the controls as speed picks up.

  set pidPitch to stuco_pid_seek(pidPitch, targetPitch, pitch_for(ship)).
  set ship:control:pitch to pidPitch["control"]["curr"] * min(1, 50 / ship:airspeed).//start damping the controls as speed picks up.

  if scienceLocations["desert"][0]:bearing < 1 and scienceLocations["desert"][0]:bearing > -1 {
    set targetRoll to 0.
  } else {
    set targetRoll to
      2 * min(
        25,
        max(
          -25,
          scienceLocations["desert"][0]:bearing
        )
      ).
  }
  set pidRoll to stuco_pid_seek(pidRoll, targetRoll, roll_for(ship)).
  set ship:control:roll to pidRoll["control"]["curr"] * min(1, 50 / ship:airspeed).
  clearscreen.
  print "bearing to next location: " + scienceLocations["desert"][0]:bearing.
  print "distance to location: " + latlng_distance(scienceLocations["desert"][0]).
  wait 0.01.
}
//drop and attempt to descend
stage.
wait 3.
stage.
wait 0.5.
lock throttle to 0.
gear on.
brakes on.
until 0 {
  set targetPitch to 0.
  set pidPitch to stuco_pid_seek(pidPitch, targetPitch, pitch_for(ship)).
  set ship:control:pitch to pidPitch["control"]["curr"] * min(1, 50 / ship:airspeed).

  set targetRoll to 30.
  set pidRoll to stuco_pid_seek(pidRoll, targetRoll, roll_for(ship)).
  set ship:control:roll to pidRoll["control"]["curr"].
  wait 0.01.
}
