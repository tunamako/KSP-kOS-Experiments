function store_sensors {
  local sensor_modules is ship:modulesnamed("ModuleScienceExperiment").
  for sensor_module in sensor_modules {
    if sensor_module:hasdata {
      sensor_module:dump.
    }
    sensor_module:deploy.
    local experiment_start is time:seconds.
    wait until sensor_module:hasdata or time:seconds > experiment_start + 10.
    if sensor_module:hasdata {
      print "Completed experiment: " + sensor_module:data[0]:title + ".".
    } else {
      print "Sensor experiment failed: " + sensor_module.
    }
  }
}

function store_deployables {
  local deployable_modules is ship:modulesnamed("DMModuleScienceAnimate").
  for deployable_module in deployable_modules {
    if deployable_module:hasdata {
      deployable_module:dump.
    }
    deployable_module:deploy.
    local experiment_start is time:seconds.
    wait until deployable_module:hasdata or time:seconds > experiment_start + 10.
    if deployable_module:hasdata {
      print "Completed experiment: " + deployable_module:data[0]:title + ".".
      wait 5.
      deployable_module:toggle().
    } else {
      print "Deployable experiment failed: " + deployable_module.
    }
  }
}

wait until ship:altitude > 255000.

store_sensors().
store_deployables().
wait until ship:orbit:body = body("mun").

rm["set"]("rm4_calc_mun_capture").
