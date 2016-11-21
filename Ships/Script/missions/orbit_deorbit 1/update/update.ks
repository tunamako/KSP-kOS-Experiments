
local connected is 0.
lock connected to addons:rt:haskscconnection(ship).

if not connected {

  set comm_targets to lib["util"]["all_targets"]().
  print comm_targets.

  set comm_modules to ship:modulesnamed("ModuleRTAntenna").
  set activating_modules to list().
  for comm_module in comm_modules {
    //activate things
    if comm_module:hasevent("activate"){
      activating_modules:add(comm_module).
      comm_module:doevent("activate").
    }
    for activating_module in activating_modules {//not sure if dishes take some time to open
      wait until comm_module:hasevent("deactivate").
    }

    //point things that can be pointed.
    for comm_target in comm_targets {
      for comm_module in comm_modules {
        if comm_module:hasfield("target") {
          comm_module:setfield("target", comm_target).
        }
      }
      if connected {
        break.
      }
    }
  }
  if not connected {
    print "no connection possible".
  } else {
    print "connected awoo".
  }
} else { print "connected awoo". }
