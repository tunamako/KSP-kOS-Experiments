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
local node_time is time:seconds + eta:periapsis. // 5 hours from the mun soi

local _seek_prograde is {
  parameter
    guess,
    step.
  set guesses["prograde"] to guess.
  //prepare test environment
  set test_node to node(node_time, 0, 0, guesses["prograde"]).
  _clear_nodes().
  add test_node. wait until hasnode. // fix for a game delay when adding nodes
  //success constraints
  if step < 10^(-3) {return true.}//if we've honed
  //failure constraints
  if nextnode:orbit:hasnextpatch {return 0.} // entering a new soi
  //conduct hill measurement
  local hill_result is hill["hills"]["alt"](nextnode:orbit:periapsis, nextnode:orbit:apoapsis, body("mun")).
  //numeric score
  return hill_result.
}.


print hill["climb"](_seek_prograde, 0).
print "done".
wait until nextnode:eta < 1 * 60.

rm["set"]("rm2_do_mun_circularize").
