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

local _seek_prograde is {
  parameter
    guess,
    step.
  //success constraints
  if step < 10^(-1) {return true.}//if we've honed
  //failure constraints
  if guess <= 0 {return 0.}//don't burn backwards
  //prepare test environment
  set test_node to node(time_guess, 0, 0, guess).
  _clear_nodes().
  add test_node. wait until hasnode. // fix for a game delay when adding nodes
  local node_apoapsis_time is
    time:seconds + nextnode:eta + nextnode:orbit:period / 2.
  //conduct hill measurement
  local hill_result is hill["hills"]["enc"](body("mun"), ship, node_apoapsis_time).
  //numeric score
  return hill_result.
}.

local _seek_time is {
  parameter
    guess,
    step.
  //success constraints
  if step < 10^(-1) {return true.}//if we've honed
  //failure constraints
  if guess < time:seconds + 0.25 * ship:orbit:period or // give yourself time before the node
    guess > time:seconds + ship:orbit:period {return 0.} // keep the node in this period
  //prepare test environment
  _clear_nodes().
  set time_guess to guess.
  local test_prograde is hill["climb"](_seek_prograde, prograde_guess, 50).
  set test_node to node(time_guess, 0, 0, test_prograde).
  _clear_nodes().
  add test_node. wait until hasnode. // fix for a game delay when adding nodes
  local node_apoapsis_time is
    time:seconds + nextnode:eta + nextnode:orbit:period / 2.
  //conduct hill measurement
  local hill_result is hill["hills"]["enc"](body("mun"), ship, node_apoapsis_time).
  print hill_result.
  //numeric score
  return hill_result.
}.

global test_node is 0.
local time_guess is time:seconds + ship:orbit:period / 2. // test a node halfway around the orbit
local prograde_guess is 800.

print hill["climb"](_seek_time, time_guess, 0.1 * ship:orbit:period).
print "done".
print "node has next patch:". print nextnode:orbit:hasnextpatch.
print "node next patch body:". print nextnode:orbit:nextpatch:body.
print "node next patch periapsis:". print nextnode:orbit:nextpatch:periapsis.


rm["set"]("rm2_do_mun_encounter").
