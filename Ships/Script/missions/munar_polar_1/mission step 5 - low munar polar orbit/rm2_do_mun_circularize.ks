
toggle ag4. //engine on
{
  //copy-pasted from https://ksp-kos.github.io/KOS/tutorials/exenode.html plus corrections
  local nd is nextnode.
  print "Node in: " + round(nd:eta) + ", DeltaV: " + round(nd:deltav:mag).
  local max_acc is ship:maxthrust/ship:mass.
  local burn_duration is nd:deltav:mag/max_acc.
  print "Crude Estimated burn duration: " + round(burn_duration) + "s".

  local np is nd:deltav.
  lock steering to nd:burnvector.
  wait until nd:eta <= (burn_duration/2).
  local tset is 0.
  lock throttle to tset.
  local dv0 is nd:deltav.
  until false {
    set max_acc to ship:maxthrust/ship:mass.
    set tset to min(nd:deltav:mag/max_acc, 1).
    if vdot(dv0, nd:deltav) < 0 {//done
      print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
      lock throttle to 0.
      break.
    }
    if nd:deltav:mag < 0.1 {
      print "Finalizing burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
      wait until vdot(dv0, nd:deltav) < 0.5.
      lock throttle to 0.
      print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
      break.
    }
  }
  unlock steering.
  unlock throttle.
  remove nd.
}
toggle ag4. //engine off (safety)
rm["set"]("rm3_mission_step_6").
