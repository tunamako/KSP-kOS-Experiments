@lazyglobal off.
clearscreen.
runoncepath("import").
local hill is import("lib/hill").
local eq is import("lib/equations").
local logistic is eq["logistic"](1, 10^(-6)).

local _clear_nodes is {
  until not hasnode {
    local node_count is allnodes:length.
    remove nextnode.
    wait until allnodes:length <> node_count.
  }
  return true.
}.

global test_node is 0.
global guesses is lex().
local node_time is time:seconds + ship:orbit:nextpatcheta - (4*60*60). // 5 hours from the mun soi

local _seek_prograde is {
  parameter
    guess,
    step.
  set guesses["prograde"] to guess.
  //prepare test environment
  set test_node to node(node_time, 0, guesses["normal"], guesses["prograde"]).
  _clear_nodes().
  add test_node. wait until hasnode. // fix for a game delay when adding nodes
  //success constraints
  if step < 10^(-3) {return true.}//if we've honed
  //failure constraints
  if not nextnode:orbit:hasnextpatch {return 0.} // not entering a new soi
  if nextnode:orbit:hasnextpatch and nextnode:orbit:nextpatch:body <> body("mun") {return 0.} // your next soi isn't the mun
  //conduct hill measurement
  local hill_result is hill["hills"]["alt"](20000, nextnode:orbit:nextpatch:periapsis, body("mun")).
  //numeric score
  return hill_result.
}.

local _seek_normal is {
  parameter
    guess,
    step.
  set guesses["normal"] to guess.
  //prepare test environment
  _clear_nodes().
  local test_prograde is hill["climb"](_seek_prograde).
  set test_node to node(node_time, 0, guesses["normal"], test_prograde).
  _clear_nodes().
  add test_node. wait until hasnode. // fix for a game delay when adding nodes
  //success constraints
  if step < 10^(-3) {return true.}//if we've honed
  //failure constraints
  if not nextnode:orbit:hasnextpatch {return 0.} // not entering a new soi
  if nextnode:orbit:hasnextpatch and nextnode:orbit:nextpatch:body <> body("mun") {return 0.} // your next soi isn't the mun
  //conduct hill measurement
  local hill_result is hill["hills"]["inc"](90, nextnode:orbit:nextpatch:inclination).
  print hill_result.
  //numeric score
  return hill_result.
}.


print hill["climb"](_seek_normal).
print "done".
print "node has next patch:". print nextnode:orbit:hasnextpatch.
print "node next patch body:". print nextnode:orbit:nextpatch:body.
print "node next patch periapsis:". print nextnode:orbit:nextpatch:periapsis.


rm["set"]("rm3_do_mun_correction").
