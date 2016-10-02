@lazyglobal off.
clearscreen.
toggle ag1.

copypath("0:/KSLib-master/library/lib_pid", "").
run lib_pid.
copypath("0:/KSLib-master/library/lib_navball", "").
run lib_navball.
print "Dependencies loaded. Initializing...".

global speedPID is PID_init(0.05, 0.01, 0.01, -1, 1).
global pitchPID is PID_init(.05, .005, .03, -1, 1).
global targetSpeed is 0.
global targetPitch is 0.
global angleAboveHorizon is 0.
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
set targetSpeed to 700.
set targetPitch to 90.
until ship:altitude > 70000 {
    set ship:control:mainthrottle to PID_seek( speedPID, targetSpeed, ship:airspeed ).
    set ship:control:pitch to PID_seek(yawPID, targetYaw, pitch_for(ship)).
    wait 0.01.
}.
