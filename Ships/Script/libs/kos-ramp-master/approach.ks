/////////////////////////////////////////////////////////////////////////////
// Approach
/////////////////////////////////////////////////////////////////////////////
// Kills transverse velocity w/r/t target and establishes forward velocity.
/////////////////////////////////////////////////////////////////////////////

run once lib_dock.
run once lib_ui.

local accel is uiAssertAccel("Maneuver").
lock vel to (ship:velocity:orbit - target:velocity:orbit).
lock velR to vdot(vel, target:position:normalized) * target:position:normalized.
lock velT to vel - velR.

// Don't let unbalanced RCS mess with our velocity
rcs off.
sas off.

if target:position:mag > 5000 or vel:mag > 25 {
  run node_vel_tgt.
  local crit is 2 * vel:mag / accel.
  if nextnode:eta > crit {
    run warp(nextnode:eta - crit).
  }

  if target:position:mag / vel:mag < 30 { // Nearby target; come to a stop first
    lock steering to lookdirup(-vel:normalized, ship:facing:upvector).
    wait until vdot(-vel:normalized, ship:facing:forevector) >= 0.95.

    uiBanner("Maneuver", "Match velocity").
    lock throttle to min(vel:mag / accel, 1.0).
    wait until vel:mag < 0.5.
    set throttle to 0.
  } else if velT:mag > 1 { // Far-away target; cancel transverse velocity first
    lock steering to lookdirup(-velT:normalized, ship:facing:upvector).
    wait until vdot(-velT:normalized, ship:facing:forevector) >= 0.99.

    uiBanner("Maneuver", "Match transverse velocity").
    lock throttle to min(velT:mag / accel, 1.0).
    wait until velT:mag < 0.5.
    set throttle to 0.
  }
}

uiBanner("Maneuver", "Begin approach").
lock dot to vdot(target:position, velR).
if dot < 0 {
  lock steering to lookdirup(-velR:normalized, ship:facing:upvector).
  wait until vdot(-velR:normalized, ship:facing:forevector) >= 0.9.
  unlock steering.
  lock throttle to 1.
  wait until dot > 0.
  set throttle to 0.
  sas off.
}
unlock dot.

lock steering to lookdirup(velR:normalized, ship:facing:upvector).
wait until vdot(velR:normalized, ship:facing:forevector) >= 0.9.

local t0 is time:seconds.
lock throttle to 1.
wait until target:position:mag / velR:mag < (time:seconds - t0 + 5) or vel:mag > 100.
set throttle to 0.
local dt is time:seconds - t0.

lock steering to lookdirup(-velR:normalized, ship:facing:upvector).
wait until vdot(-velR:normalized, ship:facing:forevector) >= 0.99.
local stopDistance is 0.5 * accel * (vel:mag / accel)^2.
local dt is (target:position:mag - stopDistance - 10) / vel:mag.
run warp(dt).

dockMatchVelocity(max(1.0, min(10.0, target:position:mag / 60.0))).

unlock velR.
unlock velT.
unlock vel.

sas on.
