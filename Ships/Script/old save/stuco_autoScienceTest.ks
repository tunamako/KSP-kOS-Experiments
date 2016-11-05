@lazyglobal off.
clearscreen.
toggle ag1.

function inspect_module_interface {
  parameter module.
  local interface is lexicon(
    "allFields", lexicon(),
    "allEvents", module:allEvents,
    "allActions", module:allActions
  ).
  for field in module:allFieldNames {
    set interface["allFields"][field] to module:getField(field).
  }
  return interface.
}

function inspect_part_modules {
  parameter part.
  local modules is lexicon().
  local moduleNames is part:modules.
  for moduleName in moduleNames {
    set modules[moduleName] to inspect_module_interface(part:getmodule(moduleName)).
  }
  return modules.
}.

function inspect_vessel_parts {
  parameter vessel is ship.
  local partsList is lexicon().
  for part in ship:parts {
    set partsList[part:uid] to lexicon(
      "name", part:name,
      "title", part:title,
      "tag", part:tag,
      "modules", inspect_part_modules(part)
    ).
  }
  return partsList.
}

log inspect_vessel_parts() to "0:/wahoutput.txt".
print inspect_vessel_parts().
