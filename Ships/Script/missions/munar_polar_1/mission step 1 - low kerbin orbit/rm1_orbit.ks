wait 5.
lock throttle to 1.
stage.
local ascent_profile is list(
  //byAltitude, targetPitch, targetThrottle
  list(    0,  90, 1.0),//at launch; instantly referenced as "previous_step"
  list( 5000,  80, 0.6),
  list(15000,  50, 0.9),
  list(45000,  20, 0.2),
  list(52000,  15, 1.0),
  list(69000,   0, 1.0)
).
until ascent_profile:length = 1 {
  local previous_step is ascent_profile[0].
  local ascent_step is ascent_profile[1].
  until ship:altitude > ascent_step[0] {//first step is instantly achieved; should skip
    //do ascent step math things
    local alt_delta is (ascent_step[0] - previous_step[0]).
    local alt_progress_pct is (ship:altitude - previous_step[0]) / alt_delta.
    //do pitch
    local pitch_delta is (ascent_step[1] - previous_step[1]).
    local target_pitch is previous_step[1] + pitch_delta * alt_progress_pct.
    //do throttle
    local throttle_delta is (ascent_step[2] - previous_step[2]).
    local target_throttle is previous_step[2] + throttle_delta * alt_progress_pct.
    //update the vessel controls
    lock steering to heading(90, target_pitch).
    lock throttle to target_throttle.
    clearscreen.
    print lexicon(
      "ascent_step", ascent_step,
      "previous_step", previous_step,
      "alt_progress_pct", alt_progress_pct,
      "target_pitch", target_pitch,
      "target_throttle", target_throttle
    ).
    if ship:maxthrust < 0.1 {stage.}
    if ship:orbit:apoapsis > 85500 {
      print "apoapsis achieved: " + ship:orbit:apoapsis.
      break.
    }
    wait 0.01.
  }
  //ascent_step complete; shift list
  ascent_profile:remove(0).
}
lock throttle to 0.0.
lock steering to ship:prograde.
wait until eta:apoapsis < 10.
lock throttle to 1.
until max(ship:orbit:periapsis, 0) > 85000 {
  if ship:maxthrust < 0.1 {stage.}
  if eta:apoapsis < 20 or eta:apoapsis > eta:periapsis {
    lock throttle to 1.
  } else {
    lock throttle to 0.
  }
  clearscreen.
  print "periapsis: " + ship:orbit:periapsis.
  wait 0.01.
}
unlock throttle.
unlock steering.
toggle ag2. // panels, antenna, and dish on
ship:partstagged("dish")[0]:getmodule("ModuleRTAntenna"):setfield("target", kerbin).
toggle ag4. //engine off (safety)


rm["set"]("rm2_mission_step_2").
