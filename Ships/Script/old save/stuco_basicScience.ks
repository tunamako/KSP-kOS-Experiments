//first mission. basic instruments on a hopped-up booster.
@lazyglobal off.
clearscreen.

function scienceModule_doAndSend {
  parameter experimentModule. //partsmodule

  experimentModule:deploy().
  wait until experimentModule:hasData.
  experimentModule:transmit().
}

function doAndSendExperiments {
  parameter experimentPartNames. //list
  parameter craft is ship. //vessel

  for partName in experimentPartNames {
    local scienceModule is craft:partsnamed(partName)[0]:getmodule("ModuleScienceExperiment").
    scienceModule_doAndSend(scienceModule).
  }
}

wait 5.
set ship:type to "Probe".
lock steering to heading(90,90).
doAndSendExperiments(list("sensorBarometer", "setiProbeStack1"), ship).
stage.
local stageStart is missiontime.
wait until ship:altitude > 500.
doAndSendExperiments(list("sensorBarometer", "setiProbeStack1"), ship).
wait until ship:altitude > 18000.
doAndSendExperiments(list("sensorBarometer", "setiProbeStack1"), ship).
wait until ship:altitude > 70000.
unlock steering.
doAndSendExperiments(list("sensorBarometer", "setiProbeStack1"), ship).
wait until alt:radar < 1000.
stage.
