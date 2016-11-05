copypath("0:/KSLib-master/library/lib_navball", "").
run lib_navball.

toggle ag1. clearscreen. wait 1.
ship:partstagged("controlpod")[0]:controlfrom().
toggle ag2. wait 1.//retract solar panels
toggle ag2. wait 5.//solar panel bug requires double-toggle.
toggle ag3. wait 2.//close bay doors
lock throttle to 1.
stage.

//solid lifting
until ship:solidfuel < 136 {//solid fuel 15%
  clearscreen.
  print "lifting.".
  print "solidfuel proportion left: " + (ship:solidfuel / 880).
  lock steering to heading(90, 90 - altitude * (90 / 40000)).
  wait 0.01.
}
//staging prepping
unlock steering.
until ship:solidfuel < 0.1 {//solid fuel 0%
  clearscreen.
  print "streamlining.".
  print "solidfuel proportion left: " + (ship:solidfuel / 880).
  wait 0.01.
}
//staging
clearscreen.
print "staging.".
stage.
sas on.
wait 2.
sas off.
local secondStageStart is lexicon(
  "pitch", pitch_for(ship),
  "altitude", altitude
).
//burn until apoapsis ensured
until apoapsis > 80000 {
  clearscreen.
  print "burn until apoapsis ensured.".
  print "second stage start: " + secondStageStart.
  print "current pitch: " + pitch_for(ship).

  local pTo70km is (altitude - secondStageStart["altitude"])
  / (60000 - secondStageStart["altitude"]).
  print "pTo70km: " + pTo70km.

  local pitchOffset is secondStageStart["pitch"] * (-1) * pTo70km.
  print "pitchOffset: " + pitchOffset.

  local targetPitch is secondStageStart["pitch"] + pitchOffset.
  print "targetPitch: " + targetPitch.

  lock steering to heading(90, targetPitch).
  wait 0.01.
}
//straighten ship for aerodynamics, then coast
lock steering to prograde.
wait 3.
lock throttle to 0.
set warpmode to "physics".
set warp to 3.
wait until altitude > 70000.
set warp to 0.
set warpmode to "rails".
set warp to 3.
wait until eta:apoapsis < 45.
set warp to 0.
lock steering to heading(90,0).
wait until eta:apoapsis < 18.
local targetPeriapsis is apoapsis.
until periapsis > targetPeriapsis {
  clearscreen.
  local targetPitch is 0.
  print "eta:periapsis " + eta:periapsis.
  print "eta:apoapsis " + eta:apoapsis.
  if(eta:periapsis < eta:apoapsis) {
    set targetPitch to 0.
  } else {
    local targetApoapsisLead is 10.

    set targetPitch to (-1) * min(90, eta:apoapsis - targetApoapsisLead).
  }
  lock steering to heading(90, targetPitch).
  lock throttle to min(1, (targetPeriapsis - periapsis) / 10000).
  wait 0.01.
}
unlock steering.
lock throttle to (-1).
toggle ag3.
toggle ag2.
clearscreen.
print "coast for one hour.".
wait 10.
local warpStart is time:seconds.
local warpDuration is 60 * 60.
set warpmode to "rails".
set warp to 3.
wait until (time:seconds > warpStart + warpDuration) and (abs(longitude - 40) < 10).
set warp to 0.
clearscreen.
print "deorbit longitude: " + longitude.
print "deorbit burn.".
lock steering to retrograde.
toggle ag2. wait 5.
toggle ag3. wait 5.
lock throttle to 0.1.
wait until periapsis < 3000.
lock throttle to 0.
unlock steering.
wait 1.
stage.
print "wait for drogue chute.".
wait 2.
set warpmode to "rails".
set warp to 3.
wait until (altitude < 70000).
set warp to 0.
wait 2.
set warpmode to "physics".
set warp to 3.
wait until alt:radar < 2500.
stage.
print "wait for main chute.".
wait until alt:radar < 1000.
stage.
wait until alt:radar < 20.
set warp to 0.
print "exit".
