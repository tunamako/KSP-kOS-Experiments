//launch the thing
@lazyglobal off.
set ship:control:pilotmainthrottle to 0.

function set_runmode {
  parameter runmode is "".
  cd("1:/").
  if exists("runmode.ks") {
    deletepath("runmode.ks").
  }
  local runmode_statement is "global runmode is " + runmode + ".".
  log runmode_statement to "runmode.ks".
}
function get_runmode {
  cd("1:/").
  if not exists("runmode.ks") {
    set_runmode(0).
  }
  runpath("runmode.ks").
}

get_runmode().

//get to orbit.
if runmode = 0 {
  wait 5.
  lock throttle to 1.
  stage.
  local ascent_profile is list(
    //byAltitude, targetPitch, targetThrottle
    list(    0,  90, 1.0),//at launch; instantly referenced as "previous_step"
    list(10000,  65, 0.7),
    list(40000,  10, 0.5),
    list(70000,   0, 0.4)
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
      lock steering to heading(-3, target_pitch).
      lock throttle to target_throttle.
      clearscreen.
      print lexicon(
        "ascent_step", ascent_step,
        "previous_step", previous_step,
        "alt_progress_pct", alt_progress_pct,
        "target_pitch", target_pitch,
        "target_throttle", target_throttle
      ).
      if ship:orbit:apoapsis > 70100 {
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
  panels on.
  lock throttle to 1.
  until max(ship:orbit:periapsis, 0) > 70000 {
    if ship:maxthrust < 0.1 {
      lock throttle to 0. wait 1.
      stage. wait 1.
    }
    if eta:apoapsis < 10 and eta:apoapsis < eta:periapsis {
      lock throttle to 1.
    } else {
      lock throttle to 0.
    }
    clearscreen.
    print "periapsis: " + ship:orbit:periapsis.
    wait 0.01.
  }
  unlock throttle.
  //start the radar scanner.
  local scansat is ship:partsnamed("SCANSAT.Scanner")[0].
  local scansat_module is scansat:getmodule("SCANsat").
  scansat_module:doevent("start radar scan").
  set_runmode(1).
  reboot.
}

//do telescope science.
if runmode = 1 {
  local telescope is ship:partsnamed("dmscope")[0]:getmodule("DMModuleScienceAnimate").
  print "deploying telescope".
  telescope:deploy().
  wait until telescope:hasdata.
  if telescope:data[0]:transmitvalue > 0 {
    print "valuable data: " + telescope:data[0]:title.
    print "waiting for datalink".
    wait until addons:rt:hasconnection(ship).
    print "transmitting".
    telescope:transmit.
  }else{
    print "junk data. dumping".
    telescope:dump().
  }
  //ToDo: update scansat data if there's a connection
  wait 10.
  clearscreen.
  set_runmode(1).
  reboot.
}
