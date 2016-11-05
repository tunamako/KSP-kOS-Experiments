@lazyglobal off.
clearscreen.
brakes on.
wait 5.

function generic_doAndSend {//thermometer, barometer, seismometer
  parameter experimentModule.

  experimentModule:deploy().
  wait until experimentModule:hasData.
  experimentModule:transmit().
  return true.
}

function magnetometer_doAndSend {
  parameter experimentModule.

  experimentModule:DEPLOY.
  WAIT UNTIL experimentModule:HASDATA.
  experimentModule:TRANSMIT.
}

function doAndSendExperiments {
  generic_doAndSend(ship:partsnamed("sensorBarometer")[0]:getmodule("ModuleScienceExperiment")).
  generic_doAndSend(ship:partsnamed("setiProbeStack1")[0]:getmodule("ModuleScienceExperiment")).
  generic_doAndSend(ship:partsnamed("sensorAccelerometer")[0]:getmodule("ModuleScienceExperiment")).
  generic_doAndSend(ship:partsnamed("dmmagBoom")[0]:getmodule("dmmodulescienceanimate")).
  return true.
}

function driveTo {
  parameter coords.
  brakes off.
  lock wheelsteering to coords.
  until coords:distance < 10 {
    if ship:groundspeed < 8 {//super jumpy and inefficient but iegaf
      lock wheelthrottle to 1.
    }else{
      lock wheelthrottle to 0.
    }
    wait 0.01.
  }
  lock wheelthrottle to 0.
  brakes on.
}

local locations is list(
  latlng(-0.0940418247485912, 285.33598068904),//admin
  latlng(-0.107485797711095, 285.348413497517),//rnd
  latlng(-0.0844935269671136, -74.6531615639102),//astronaut complex (missed)
  latlng(-0.0811306433569743, 285.365420404629),//SPH
  latlng(-0.079855831964012, 285.383680499618),//mission control
  latlng(-0.0923318464212637, 285.383400392511),//VAB
  latlng(-0.096892580158935, 285.396274742116),//crawlerway
  latlng(-0.119820993641748, 285.396970277844),//tracking station
  latlng(-0.115673088061891, 285.412015248504),//KSC general
  latlng(-0.0972413736714619, 285.44238127157)//launchpad
).

doAndSendExperiments().
wait 3.
for biome in locations {
  driveTo(biome).
  doAndSendExperiments().
}
