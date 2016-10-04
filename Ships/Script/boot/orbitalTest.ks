@lazyglobal off.
clearscreen.
toggle ag1.

copypath("0:/KSLib-master/library/lib_pid", "").
run lib_pid.
copypath("0:/KSLib-master/library/lib_navball", "").
run lib_navball.
print "Dependencies loaded. Initializing...".

global speedPID is PID_init(0.05, 0.01, 0.01, -1, 1).
global pitchPID is PID_init(.05, .001, .02, -.8, .8).
global yawPID is PID_init(.05, .001, .02, -.8, .8).
global targetSpeed is 0.
global targetPitch is 0.
global targetYaw is 0.
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

//set ship:control:mainthrottle to 1.0.
//wait until ship:airspeed > 100.

set targetSpeed to 1000.
set targetPitch to 0.
set targetYaw to 0.
until ship:airspeed > 100 {
    set ship:control:mainthrottle to PID_seek( speedPID, targetSpeed, ship:airspeed ).
    set ship:control:yaw to PID_seek(yawPID, targetYaw, sin(compass_for(ship))*pitch_for(ship)).
    set ship:control:pitch to PID_seek(pitchPID, targetPitch, cos(compass_for(ship))*pitch_for(ship)).
    wait 0.01.
}.

//Perform gravity turn
set targetSpeed to 1000.
set targetPitch to 90.
set targetYaw to 0.
until ship:altitude > 70000 {
    set ship:control:mainthrottle to PID_seek( speedPID, targetSpeed, ship:airspeed ).
    set ship:control:yaw to PID_seek(yawPID, targetYaw, sin(compass_for(ship))*pitch_for(ship)).
    set ship:control:pitch to PID_seek(pitchPID, targetPitch, cos(compass_for(ship))*pitch_for(ship)).
    wait 0.01.
}.
