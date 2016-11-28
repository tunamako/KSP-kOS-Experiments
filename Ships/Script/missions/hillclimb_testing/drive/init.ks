toggle ag1.


local scorer is {
  parameter x.
  return -1*(x+5)*(2*x-1)*(x+10)*(3*x-3).
}.
local guess is -10.1.
local stepsize is 1.

local high_score is scorer(guess).
until stepsize < 0.01 {
  local upward_score is scorer(guess + stepsize).
  if upward_score > high_score {//rabase, climb at double pace
    set guess to guess + stepsize.
    set stepsize to stepsize * 2.
    set high_score to upward_score.
  } else {
    local downward_score is scorer(guess - stepsize).
    if downward_score > high_score {//rabase, climb at double pace
      set guess to guess - stepsize.
      set stepsize to stepsize * 2.
      set high_score to downward_score.
    } else {//keep base, cut step
      set stepsize to stepsize / 2.
    }
  }
  print lex(
    "guess", guess,
    "stepsize", stepsize,
    "high_score", high_score
  ).
  wait 1.
}


print "completed".
wait until false.
