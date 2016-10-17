@lazyglobal off.
clearscreen.
toggle ag3.

copypath("0:/KSLib-master/library/lib_pid", "").
run lib_pid.
copypath("0:/KSLib-master/library/lib_navball", "").
run lib_navball.
print "Dependencies loaded. Initializing...".

global speedPID is PID_init(0.05, 0.01, 0.01, -1, 1).
global pitchPID is PID_init(.005, 0, .02, -1, 1).
global yawPID is PID_init(.005, 0, .02, -1, 1).
global targetSpeed is 0.
global targetPitch is 0.
global targetYaw is 0.
global currentYaw is 0.
global currentPitch is 0.
print "Init complete. Launching...".

//Handle stage transitions
when ship:maxthrust < 0.1 then {
    if STAGE:NUMBER = 1 {
        wait until ship:velocity:surface:MAG < 800.
    }.
    print "Staging...".
    stage.
    preserve.
}.

//Perform gravity turn
set targetSpeed to 1000.
set targetPitch to 90.
set targetYaw to 90.
until ship:altitude > 70000 {
    set currentYaw to arctan(sin(pitch_for(ship))/sin(mod(compass_for(ship), 90))).
    set currentPitch to arctan(sin(pitch_for(ship))/cos(mod(compass_for(ship), 90))).
    set ship:control:mainthrottle to PID_seek( speedPID, targetSpeed, ship:airspeed ).
    set ship:control:yaw to PID_seek(yawPID, targetYaw, currentYaw).
    set ship:control:pitch to PID_seek(pitchPID, targetPitch, currentPitch).
    print "Yaw:" + round(currentYaw, 1) at (8, 4).
    print "Pitch:" + round(currentPitch, 1) at (8, 5).
    print "Roll:" + round(ship:control:roll, 1) at (8, 6).
    wait 0.01.
}.
