if defined lib = false {global lib is lexicon().}
if lib:haskey("util") = false {set lib["util"] to lexicon().}


set lib["util"]["all_comm_targets"] to {

  set groundstation_targets to addons:rt:groundstations.
  list bodies in body_targets.
  list targets in vessel_targets.

  return lib["core"]["list_merge"](
    list(groundstation_targets, body_targets, vessel_targets) ).
}.
