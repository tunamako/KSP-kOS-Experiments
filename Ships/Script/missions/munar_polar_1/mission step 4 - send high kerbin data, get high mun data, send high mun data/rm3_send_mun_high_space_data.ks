local science_modules is list().
for sublist in list(
  ship:modulesnamed("DMModuleScienceAnimate"),
  ship:modulesnamed("ModuleScienceExperiment")
) {
  for sublist_item in sublist {
    science_modules:add(sublist_item).
  }
}

for science_module in science_modules {
  if science_module:hasdata {
    if science_module:data[0]:transmitvalue > 0 {
      wait until ship:electriccharge > 400 and addons:rt:haskscconnection(ship).
      print "transmitting data".
      wait until addons:rt:haskscconnection(ship).
      science_module:transmit.
    } else {
      science_module:dump().
    }
  }
}

rm["set"]("rm4_mission_step_5").
