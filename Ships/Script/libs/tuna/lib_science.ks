if defined lib = false {global lib is lexicon().}
if lib:haskey("util") = false {set lib["util"] to lexicon().}

local science_modules is ship:modulesnamed("ModuleScienceExperiment").
local magnetometer is ship:modulesnamed("dmmodulescienceanimate")[0].

set lib["util"]["do_experiments"] to {
    parameter exceptions is list().

    for science_module in science_modules {
        if not exceptions:contains(science_module:part:name) {
            science_module:deploy.
            wait until science_module:hasdata.
            print "Completed experiment: " + science_module:data[0]:title + ".".
        }
    }
}
set lib["util"]["do_magnetometer"] to {
    magnetometer:deploy.
    wait until magnetometer:hasdata.
    wait 5.
    print "Completed experiment: " + magnetometer:data[0]:title + ".".
    magnetometer:toggle().
}
set lib["util"]["transmit_data"] to {
    for science_module in science_modules {
        if science_module:hasdata {science_module:transmit.}
    }
    if magnetometer:hasdata {magnetometer:transmit.}.
}
