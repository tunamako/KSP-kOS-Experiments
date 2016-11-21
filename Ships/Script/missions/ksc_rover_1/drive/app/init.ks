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
    if science_module:hasdata {
      set transmitted_science_value to transmitted_science_value + science_module:data[0]:transmitvalue.
      set transmitted_data_amount to transmitted_data_amount + science_module:data[0]:dataamount.
      science_module:transmit.
    }
  }
}

local target_locations is list(
	lexicon("name", "runway",
		"latitude", -0.0488636223154306,
		"longitude", -74.6617415631349),
	lexicon("name", "administration",
		"latitude", -0.0948565369725821,
		"longitude", -74.659406333723),
	lexicon("name", "r+d",
		"latitude", -0.103689359847246,
		"longitude", -74.6392563260982),
	lexicon("name", "sph",
		"latitude", -0.0821290958164431,
		"longitude", -74.6329935638011),
	lexicon("name", "mission control",
		"latitude", -0.0792643052008403,
		"longitude", -74.6157004432697),
	lexicon("name", "vab",
		"latitude", -0.0893573439489955,
		"longitude", -74.616188688364),
	lexicon("name", "tracking station",
		"latitude", -0.123178741794121,
		"longitude", -74.6038611414014),
	lexicon("name", "launchpad",
		"latitude", -0.0971306570244585,
		"longitude", -74.5578643820082),
  lexicon("name", "crawlerway",
    "latitude", -0.0968542604080063,
    "longitude", -74.6004480595033),
	lexicon("name", "ksc",
		"latitude", -0.149860975045694,
		"longitude", -74.597335575311),
  lexicon("name", "shores",
    "latitude", -0.206823620306063,
    "longitude", -74.7802090771389),
  lexicon("name", "grasslands",
    "latitude", -0.162031260725079,
    "longitude", -74.9343107621618),
  lexicon("name", "runway (home)",
		"latitude", -0.0488636223154306,
		"longitude", -74.6617415631349)
).

local steering_controller is lib["util"]["stuco_pid_init"](
  -1, 1, 2,
  lib["util"]["stuco_component_init"](0.003)
).
local target_distance is 0.
local last_target_distance is 0.
local transmitted_data_amount is 0.
local transmitted_science_value is 0.


toggle ag1.

for target_location in target_locations {
  lock target_distance to sqrt(
    (ship:latitude - target_location["latitude"])^2 +
    (ship:longitude - target_location["longitude"])^2
  ).

  until target_distance > last_target_distance and target_distance < 0.001 {
    set steering_controller to lib["util"]["stuco_pid_seek"](
      steering_controller, 0, latlng(target_location["latitude"],target_location["longitude"]):bearing).
    set ship:control:wheelsteer to steering_controller["control"]["curr"].
    if ship:groundspeed < 10 {set ship:control:wheelthrottle to 1.}
    else {set ship:control:wheelthrottle to 0.}
    set last_target_distance to target_distance.
    clearscreen.
    print "Driving to: " + target_location["name"].
    print "Target distance: " + target_distance.
    print "Transmitted data amount: " + transmitted_data_amount.
    print "Transmitted science value: " + transmitted_science_value.
    wait 0.01.
  }
  do_experiments().
  transmit_data().

}.
set ship:control:wheelthrottle to 0.
brakes on.
ship:control:neutralize.
print "requesting recovery!".
