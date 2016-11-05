//ag1 camera, terminal
//ag2 inflate balloon
//ag3 deflate balloon. must arm parachute through staging.
//ag10 telemetry report
@lazyglobal off. clearscreen.


function do_science {
  local normalInstruments is list(
    "sensorBarometer",
    "sensorThermometer"
  ).
  for instrument in normalInstruments {
    local experiment is ship:partsnamed(instrument)[0]:getmodule("ModuleScienceExperiment").
    experiment:deploy().
    wait until experiment:hasData.
    print experiment:data[0]:title.
    experiment:transmit().
  }
  //can't interface with telemetry
  ag10 off. ag10 on.
  print "telemetry report".
}

set ship:type to "Probe".
ag1 on.
wait 5.
do_science().
wait 5.
ag2 on.
wait until alt:radar > 100.
do_science().
wait until altitude > 200 or ship:verticalspeed < 0.
ag3 on. stage.
wait until alt:radar < 10. wait 10.
do_science().
