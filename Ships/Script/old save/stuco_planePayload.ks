@lazyglobal off.
clearscreen.

wait until ship:mass < 1.//listen for decouple

//get atmospheric data above biome.
//temp from probestack
wait 5.
ship:partsnamed("setiProbeStack1")[0]:getmodule("ModuleScienceExperiment"):deploy().
wait until abs(ship:groundspeed) < 5.//descending
lock steering to retrograde.//try to land on your feet.
wait until abs(ship:verticalspeed) < 0.5.//landed
wait 5.
//perform ground experiments with unused science parts
ship:partsnamed("sensorThermometer")[0]:getmodule("ModuleScienceExperiment"):deploy().
ship:partsnamed("sensorBarometer")[0]:getmodule("ModuleScienceExperiment"):deploy().
ship:partsnamed("sensorAccelerometer")[0]:getmodule("ModuleScienceExperiment"):deploy().
ship:partsnamed("dmmagBoom")[0]:getmodule("dmmodulescienceanimate"):deploy().
//click "recover". end


//shores
//-0.201601652617992
//-74.7323365132676

//grasslands
//-0.306519822881281
//-74.9757792051902

//highlands
//0.731651599454657
//-77.1692303994254

//mountains
//0.681255389768304
//-79.0715661536106
