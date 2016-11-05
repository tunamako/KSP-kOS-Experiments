@lazyglobal off.
clearscreen.
wait 5.

function generic_doAndSend {//thermometer, barometer, seismometer
  parameter experimentModule.

  experimentModule:deploy().
  wait until experimentModule:hasData.
  experimentModule:transmit().
  return true.
}

stage.
lock steering to heading(90, 50).
wait until ship:altitude > 1000.
wait until ship:altitude < 1000.
unlock steering.
stage.
wait until ship:altitude < 100.
  generic_doAndSend(ship:partsnamed("sensorBarometer")[0]:getmodule("ModuleScienceExperiment")).
  generic_doAndSend(ship:partsnamed("setiProbeStack1")[0]:getmodule("ModuleScienceExperiment")).
wait until ship:altitude < -20.
  generic_doAndSend(ship:partsnamed("sensorBarometer")[0]:getmodule("ModuleScienceExperiment")).
  generic_doAndSend(ship:partsnamed("setiProbeStack1")[0]:getmodule("ModuleScienceExperiment")).
  generic_doAndSend(ship:partsnamed("dmBathymetry")[0]:getmodule("dmbathymetry")).
until abs(ship:verticalspeed) < 0.01 {
  clearscreen.
  print ship:verticalspeed.
  wait 1.
}
wait 10.
  generic_doAndSend(ship:partsnamed("sensorBarometer")[0]:getmodule("ModuleScienceExperiment")).
  generic_doAndSend(ship:partsnamed("setiProbeStack1")[0]:getmodule("ModuleScienceExperiment")).
  generic_doAndSend(ship:partsnamed("sensorAccelerometer")[0]:getmodule("ModuleScienceExperiment")).
  generic_doAndSend(ship:partsnamed("dmmagBoom")[0]:getmodule("dmmodulescienceanimate")).
  generic_doAndSend(ship:partsnamed("dmBathymetry")[0]:getmodule("dmbathymetry")).
print "end".
