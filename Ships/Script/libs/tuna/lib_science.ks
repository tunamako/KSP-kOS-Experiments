{
    local science_modules is ship:modulesnamed("ModuleScienceExperiment").

    local do_experiments is {
        parameter exceptions is list().

        for science_module in science_modules {
            if not exceptions:contains(science_module:part:name) {
                science_module:deploy.
                wait until science_module:hasdata.
                print "Completed experiment: " + science_module:data[0]:title + ".".
            }
        }
    }.
    local do_magnetometer is {
        local magnetometer is ship:partsnamed("dmmagBoom")[0]:getmodule("DMModuleScienceAnimate").
        magnetometer:deploy.
        wait until magnetometer:hasdata.
        wait 5.
        print "Completed experiment: " + magnetometer:data[0]:title + ".".
        magnetometer:toggle().
    }.

    local do_orbitatelescope is {
        local orbitalTelescope is ship:partsnamed("dmscope")[0]:getmodule("DMModuleScienceAnimate").
        orbitalTelescope:deploy.
        wait until orbitalTelescope:hasdata.
        wait 5.
        print "Completed experiment: " + orbitalTelescope:data[0]:title + ".".
        orbitalTelescope:toggle().
    }.

    local transmit_data is {
        set science_modules to lib["core"]["list_merge"](list(science_modules,ship:modulesnamed("DMModuleScienceAnimate"))).
        for science_module in science_modules {
            if science_module:hasdata and science_module:data[0]:transmitvalue > 0 {
                print "transmitting data".
                wait until addons:rt:haskscconnection(ship).
                science_module:transmit.
            } else {
                science_module:dump().
            }
        }
    }.

    export(lex(
      "ver", "0.0.1",
      "do_experiments", do_experiments@,
      "do_magnetometer", do_magnetometer@,
      "do_orbitatelescope", do_orbitatelescope@,
      "transmit_data", transmit_data@
    )).
}
