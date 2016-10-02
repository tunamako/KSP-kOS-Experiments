@lazyglobal off.
clearscreen.
toggle ag1. //toggle terminal window to visible

copypath("0:/KSLib-master/library/lib_pid", "").
run lib_pid.
copypath("0:/KSLib-master/library/lib_navball", "").
run lib_navball.
print "KSLib dependencies imported.".

global pidSpeed is 0.
global targetSpeed is 0.
global pidPitch is 0.
global targetPitch is 0.
global pidRoll is 0.
global targetRoll is 0.
global pidYaw is 0.
global targetYaw is 0.
print "Pilot PID controller and target pair globals declared.".

print "Halt with brakes.".
brakes on.
wait 2.
print "Halt complete.".

print "Takeoff until radar 200m.".
brakes off.
stage.
set pidSpeed to PID_init(.01, .0005, .003, 0, 1). //attempted to tune for jet engine
set targetSpeed to 80.
set pidPitch to PID_init(.01, .0005, .01, -.15, .15). //pitch range limited to avoid takeoff engine scraping
set targetPitch to 15.
set pidRoll to PID_init(.01, .0005, .003, -1, 1). //unbound; plenty of roll-stabilizing surface (wings)
set targetRoll to 0.
set pidYaw to PID_init(.01, .0005, .003, -.4, .4). //limited because not many yaw-stabilizing surfaces on craft
set targetYaw to 90.
until alt:radar >= 200 {
  set ship:control:mainthrottle to PID_seek(pidSpeed, targetSpeed, ship:airspeed).
  set ship:control:pitch to PID_seek(pidPitch, targetPitch, pitch_for(ship)).
  set ship:control:roll to PID_seek(pidRoll, targetRoll, roll_for(ship)).
  set ship:control:yaw to PID_seek(pidYaw, targetYaw, compass_for(ship)).
  wait 0.01.
}
gear off.
print "Takeoff complete.".

print "Bank until heading near 180 (south).".
set targetRoll to 30.
set targetYaw to 180.
until (compass_for(ship) >= 170 and compass_for(ship) <= 190) {
  set ship:control:mainthrottle to PID_seek(pidSpeed, targetSpeed, ship:airspeed).
  set ship:control:pitch to PID_seek(pidPitch, targetPitch, pitch_for(ship)).
  set ship:control:roll to PID_seek(pidRoll, targetRoll, roll_for(ship)).
  set ship:control:yaw to PID_seek(pidYaw, targetYaw, compass_for(ship)).
  wait 0.01.
}
print "Bank complete.".

print "Ascend until altitude 3000m.".
set targetSpeed to 120.
set targetPitch to 30.
set targetRoll to 0.
set targetYaw to 180.
until ship:altitude >= 3000 {
  set ship:control:mainthrottle to PID_seek(pidSpeed, targetSpeed, ship:airspeed).
  set ship:control:pitch to PID_seek(pidPitch, targetPitch, pitch_for(ship)).
  set ship:control:roll to PID_seek(pidRoll, targetRoll, roll_for(ship)).
  set ship:control:yaw to PID_seek(pidYaw, targetYaw, compass_for(ship)).
  wait 0.01.
}
print "Ascend complete.".

local duration to 30.
print "Stabilize for " + duration + " seconds.".
set targetSpeed to 80.

global pidAltitude is 0.
global targetAltitude to 3000.
set pidAltitude to PID_init(.03, .0015, .03, -1, 1).
local startTime to time:seconds.
until time:seconds >= startTime + duration {
  set ship:control:mainthrottle to PID_seek(pidSpeed, targetSpeed, ship:airspeed).
  set ship:control:pitch to PID_seek(pidPitch, targetPitch, pitch_for(ship)).

  //i'll claim that the integral of "pitch" should be "altitude", and i'll pid altitude within the pitch pid. #yolo
  set pidPitch[7] to pidPitch[7] + (0.0015 * PID_seek(pidAltitude, targetAltitude, ship:altitude)).
  set ship:control:roll to PID_seek(pidRoll, targetRoll, roll_for(ship)).
  set ship:control:yaw to PID_seek(pidYaw, targetYaw, compass_for(ship)).
  wait 0.01.
  clearscreen.
  print pidPitch.
}
print "Stabilize complete.".
