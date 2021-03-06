//ag1 camera, terminal
//ag10 telemetry report
@lazyglobal off. clearscreen.

function countdown {
  parameter remaining is 0.
  if remaining = 0 {
    print "begin ascent.".
    return.
  }
  print "T - " + remaining.
  wait 1.
  return countdown(remaining - 1).
}

function do_science {
  parameter normalInstruments is list().
  for instrument in normalInstruments {
    if instrument = "telemetry" {
      print "attempting telemetry report. transmit!".
      ag10 off. ag10 on.
    }else if instrument = "magnetometer" {
      local experiment is ship:partsnamed("dmmagBoom")[0]:getmodule("dmmodulescienceanimate").
      experiment:deploy().
      wait until experiment:hasData.
      print "transmitting experiment data: " + experiment:data[0]:title.
      experiment:transmit().
      wait 5. experiment:toggle().
    }else{
      local experiment is ship:partsnamed(instrument)[0]:getmodule("ModuleScienceExperiment").
      experiment:deploy().
      wait until experiment:hasData.
      print "transmitting experiment data: " + experiment:data[0]:title.
      experiment:transmit().
    }
  }
}
function wait_stage {
  parameter max_speed is 99999.
  wait until ship:maxthrust < 0.1 and ship:verticalspeed < max_speed.
  stage.
  print "decoupled at altitude " + round(ship:altitude) + "m.".
}


ag1 on.
wait 10. do_science(list(
  "sensorAccelerometer","magnetometer")).
countdown(10).
lock steering to heading(90,90).
stage.
wait_stage(200).
wait_stage(200).
wait_stage().
wait_stage().
wait_stage().
unlock steering.
set ship:control:roll to 1.
print "atmosphere expiring, begin spin-stabilization.".
wait_stage().//arm parachute
wait until ship:altitude > 18500. do_science(list(
  "telemetry", "sensorBarometer", "sensorThermometer")). wait 10.
wait until ship:altitude > 70020. do_science(list(
  "telemetry", "sensorBarometer","sensorThermometer","magnetometer")). wait 10.
set ship:control:neutralize to true.
wait until alt:radar < 500. do_science(list(
  "sensorThermometer")). wait 10.
wait until alt:radar < 10. wait 10. do_science(list(
  "telemetry", "sensorBarometer","sensorThermometer","sensorAccelerometer","magnetometer")). wait 10.
