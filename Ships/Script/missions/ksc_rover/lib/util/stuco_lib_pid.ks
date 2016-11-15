if defined lib = false {global lib is lexicon().}
if lib:haskey("util") = false {set lib["util"] to lexicon().}

set lib["util"]["stuco_component_init"] to {//set up a component
  parameter
    raw_coefficient is 0,
    raw_min         is -1 * 10^15,
    raw_max         is 1 * 10^15.

  return lexicon(
    "coef",      raw_coefficient,
    "curr",      0,//bounded by min and max
    "prev",      false,//these are raws
    "delta",     0,
    "min",       raw_min,
    "max",       raw_max,
    "component", lexicon(//this stuff is after the coefficient is applied
      "curr",  0,
      "prev",  0,
      "delta", 0
    )
  ).
}.

set lib["util"]["stuco_pid_init"] to {//controller template with blank components to overwrite
  parameter
    control_min        is -1 * 10^15,
    control_max        is 1 * 10^15,
    t_suspicious_delta is 2,
    error_p            is lib["util"]["stuco_component_init"](),
    error_i            is lib["util"]["stuco_component_init"](),
    error_d            is lib["util"]["stuco_component_init"]().

  return lexicon(
    "control", lexicon(//final output
      "curr",  0,
      "prev",  false,
      "delta", 0,
      "min",   control_min,
      "max",   control_max
    ),
    "t", lexicon(
      "curr",             time:seconds,
      "prev",             false,//if false, skip calculus-esque components
      "delta",            0,//if change is zero, skip calculus-esque components
      "suspicious_delta", t_suspicious_delta//if the time change is suspiciously large, skip calculus-esque components (because game warp/focus)
    ),
    "e", lexicon(
      "d", error_d,
      "p", error_p,
      "i", error_i
    )
  ).
}.

set lib["util"]["stuco_pid_seek"] to {
  parameter
    stuco_pid,
    seek_value,
    current_value.

  local skip_calculus is false.
  if stuco_pid["t"]["prev"] = false {
    set skip_calculus to true.
  }

  //do time things
  set stuco_pid["t"]["prev"] to stuco_pid["t"]["curr"].
  set stuco_pid["t"]["curr"] to time:seconds.
  set stuco_pid["t"]["delta"] to
    stuco_pid["t"]["curr"] - stuco_pid["t"]["prev"].
  if stuco_pid["t"]["delta"] > stuco_pid["t"]["suspicious_delta"] {
    set skip_calculus to true.
  }

  //error_p (proportional)
  //raw
  set stuco_pid["e"]["p"]["prev"] to stuco_pid["e"]["p"]["curr"].
  set stuco_pid["e"]["p"]["curr"] to
    max(
      stuco_pid["e"]["p"]["min"],
      min(
        stuco_pid["e"]["p"]["max"],
        seek_value - current_value ) ).
  set stuco_pid["e"]["p"]["delta"] to
    stuco_pid["e"]["p"]["curr"] - stuco_pid["e"]["p"]["prev"].
  //component
  set stuco_pid["e"]["p"]["component"]["prev"] to
    stuco_pid["e"]["p"]["component"]["curr"].
  set stuco_pid["e"]["p"]["component"]["curr"] to
    stuco_pid["e"]["p"]["curr"] * stuco_pid["e"]["p"]["coef"].
  set stuco_pid["e"]["p"]["component"]["delta"] to
    stuco_pid["e"]["p"]["component"]["curr"] - stuco_pid["e"]["p"]["component"]["prev"].

  if skip_calculus = false {
    //error_d (derivative)
    //raw
    set stuco_pid["e"]["d"]["prev"] to stuco_pid["e"]["d"]["curr"].
    set stuco_pid["e"]["d"]["curr"] to
      max(
        stuco_pid["e"]["d"]["min"],
        min(
          stuco_pid["e"]["d"]["max"],
          stuco_pid["e"]["p"]["delta"] / stuco_pid["t"]["delta"] ) ).// dp/dt
    set stuco_pid["e"]["d"]["delta"] to
      stuco_pid["e"]["d"]["curr"] - stuco_pid["e"]["d"]["prev"].
    //component
    set stuco_pid["e"]["d"]["component"]["prev"] to
      stuco_pid["e"]["d"]["component"]["curr"].
    set stuco_pid["e"]["d"]["component"]["curr"] to
      stuco_pid["e"]["d"]["curr"] * stuco_pid["e"]["d"]["coef"].
    set stuco_pid["e"]["d"]["component"]["delta"] to
      stuco_pid["e"]["d"]["component"]["curr"] - stuco_pid["e"]["d"]["component"]["prev"].

    //error_i (integral)
    //raw
    set stuco_pid["e"]["i"]["prev"] to stuco_pid["e"]["i"]["curr"].
    set stuco_pid["e"]["i"]["curr"] to
      max(
        stuco_pid["e"]["i"]["min"],
        min(
          stuco_pid["e"]["i"]["max"],
          stuco_pid["e"]["i"]["prev"] + (
            stuco_pid["e"]["p"]["curr"] * stuco_pid["t"]["delta"] ) ) ).
    set stuco_pid["e"]["i"]["delta"] to
      stuco_pid["e"]["i"]["curr"] - stuco_pid["e"]["i"]["prev"].
    //component
    set stuco_pid["e"]["i"]["component"]["prev"] to
      stuco_pid["e"]["i"]["component"]["curr"].
    set stuco_pid["e"]["i"]["component"]["curr"] to
      stuco_pid["e"]["i"]["curr"] * stuco_pid["e"]["i"]["coef"].
    set stuco_pid["e"]["i"]["component"]["delta"] to
      stuco_pid["e"]["i"]["component"]["curr"] - stuco_pid["e"]["i"]["component"]["prev"].
  }

  //control
  set stuco_pid["control"]["prev"] to stuco_pid["control"]["curr"].
  set stuco_pid["control"]["curr"] to
    max(
      stuco_pid["control"]["min"],
      min(
        stuco_pid["control"]["max"],
        stuco_pid["e"]["p"]["component"]["curr"]
      + stuco_pid["e"]["i"]["component"]["curr"]
      + stuco_pid["e"]["d"]["component"]["curr"] ) ).
  set stuco_pid["control"]["delta"] to
    stuco_pid["control"]["curr"] - stuco_pid["control"]["prev"].

  return stuco_pid.
}.
