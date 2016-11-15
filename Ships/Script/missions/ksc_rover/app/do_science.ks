local science_modules is lib["core"]["list_merge"](list(
  ship:modulesnamed("ModuleScienceExperiment"),
  ship:modulesnamed("dmmodulescienceanimate")
)).
for science_module in science_modules {
  science_module:deploy.
  wait until science_module:hasdata.
  collected_science:add(science_module:data[0]:title).
  science_module:transmit.
}
