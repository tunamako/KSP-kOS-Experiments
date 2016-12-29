{
    local science_modules is ship:modulesnamed("ModuleScienceExperiment").

    local do_experiments is {
        parameter exceptions is list().

        for science_module in science_modules {
            if not exceptions:contains(science_module:part:name) {
                if not science_module:hasdata {
                    science_module:deploy.
                }
                wait until science_module:hasdata.
                print "Completed experiment: " + science_module:data[0]:title + ".".
            }
        }
    }.
    local do_dmagic is {
        parameter dmagicParts is list("dmmagBoom","dmscope","rpwsAnt","dmImagingPlatform").
        for partName in dmagicParts {
            local part is ship:partsnamed(partName)[0]:getmodule("DMModuleScienceAnimate").
            if not part:hasdata {
                part:deploy.
                wait until part:hasdata.
                wait 5.
            }
            print "Completed experiment: " + part:data[0]:title + ".".
            part:toggle().
        }
    }.

    local transmit_data is {
        set science_modules to merge["list_merge"](list(science_modules,ship:modulesnamed("DMModuleScienceAnimate"))).
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
      "do_dmagic", do_dmagic@,
      "transmit_data", transmit_data@
    )).
}
