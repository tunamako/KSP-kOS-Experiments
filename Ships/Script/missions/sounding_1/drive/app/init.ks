local science_modules is ship:modulesnamed("ModuleScienceExperiment").

function do_experiments {
  for science_module in science_modules {
    science_module:deploy.
    wait until science_module:hasdata.
    print "Completed experiment: " + science_module:data[0]:title + ".".
  }
}

function transmit_data {
  for science_module in science_modules {
    if science_module:hasdata {science_module:transmit.}
  }
}


toggle ag1.
wait 5.

do_experiments().
transmit_data().

local countdown is 5.
until countdown = 0 {
  print "T - " + countdown.
  wait 1.
  set countdown to countdown - 1.
}
print "Liftoff!".
stage.

wait until ship:verticalspeed < -1.
print "Passed peak altitude.".
do_experiments().
transmit_data().

wait until alt:radar < 250.
stage.

wait until ship:status = "landed" or ship:status = "splashed".
print "Payload has " + ship:status + ".".
do_experiments().

print "Requesting recovery!".
