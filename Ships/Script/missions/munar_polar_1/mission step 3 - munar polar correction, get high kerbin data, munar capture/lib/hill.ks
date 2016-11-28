{
  function climb {
    parameter
      _scorer, // a function that returns true on success, or a numeric score otherwise. given a guess and a step size
      guess is 0, // a numeric initial guess for the parameter.
      step is 1, // the initial step to take up and down in the search space.
      step_factor is 2. // the multiple by which to increase or decrease the step between iterations

    local prev_best is false.
    local best_score is _scorer(guess, step).
    until 0 {
      if best_score:typename = "boolean" {break.}
      set prev_best to best_score.

      local guess_up is guess + step.
      local upward_score is _scorer(guess_up, step).


      if upward_score:typename = "boolean" or upward_score > best_score {//rabase upwards, climb at double pace

        set guess to guess_up.
        set step to step * 2.
        set best_score to upward_score.
      } else {

        local guess_down is guess - step.
        local downward_score is _scorer(guess_down, step).
        if downward_score:typename = "boolean" or downward_score > best_score {//rabase downwards, climb at double pace

          set guess to guess_down.
          set step to step * 2.
          set best_score to downward_score.
        } else {//keep base, cut step

          set step to step / step_factor.
        }
      }
    }
    return guess.
  }

  function inc_hill {
    //linear, based on percentage off of target
    //on-target returns 100%. 45deg high/low returns 50%. normal (90deg off) to target returns 0%.
    parameter
      inc_target,
      inc_test.
    local inc_delta_1 is inc_target - inc_test. // over-the-pole error
    local inc_delta_2 is ((-1) * inc_target) - inc_test. // over-the-equator error
    local inc_err is 2 * min(abs(inc_delta_1), abs(inc_delta_2)).
    local inc_range is 180.
    local inc_err_pct is inc_err / inc_range.
    return 1 - inc_err_pct.
  }

  function alt_hill {
    //linear, based on percentage off of target
    //on-target is 100%.
    parameter
      alt_target,
      alt_test,
      orbit_body. // the body we're talking about matters quite a bit.
    local alt_delta is alt_target - alt_test.
    local alt_err is abs(alt_delta).
    local alt_range is orbit_body:soiradius.
    local alt_err_pct is alt_err / alt_range.
    return max(1 - alt_err_pct, 0). // in case the error is absurdly large, like escape trajectories
  }

  function enc_hill {
    parameter
      enc_target,
      enc_test,
      at_time. // kerbal universe time in seconds at which to check the orbits' positions
    local eq is import("lib/equations").
    local enc_target_pos is positionat(enc_target, at_time). // positionat assumes completion of any nodes and follows the patch trail
    local enc_test_pos is positionat(enc_test, at_time).
    local enc_err is (enc_target_pos - enc_test_pos):mag.
    //no such thing as percentage error here, so we'll just use some function that does the job
    local _slow_decay is eq["exponential"](1, constant:e, (-1 * 10^(-10))).//decaying too fast can round to 0.
    local enc_err_val is _slow_decay(enc_err).
    return enc_err_val.
  }

  export(lex(
    "ver", "0.0.3",
    "climb", climb@, // the actual climbing routine
    "hills", lex( // definitions for various hills commonly seen in the wild
      "inc", inc_hill@, // orbital inclination
      "alt", alt_hill@, // generic altitude. handy for apoapsis and periapsis, but works for whatever
      "enc", enc_hill@ // encounter distance at a given time (protip: wrap a generic time-based hill over this!)
    )
  )).
}
