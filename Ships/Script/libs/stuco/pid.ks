{
  function comp {//set up a comp
    parameter
      raw_k is 0,
      raw_min is -1 * 10^15,
      raw_max is 1 * 10^15.

    return lexicon(
      "k", raw_k,
      "curr", 0,//bounded by min and max
      "prev", false,//these are raws
      "delta", 0,
      "min",  raw_min,
      "max",  raw_max,
      "comp", lexicon(//this stuff is after the k is applied
        "curr", 0,
        "prev", 0,
        "delta", 0
      )
    ).
  }

  function init {//ctrller template with blank comps to overwrite
    parameter
      ctrl_min is -1 * 10^15,
      ctrl_max is 1 * 10^15,
      t_susp_delta is 2,
      e_p is comp(),
      e_i is comp(),
      e_d is comp().

    return lexicon(
      "ctrl", lexicon(//final output
        "curr", 0,
        "prev", false,
        "delta", 0,
        "min", ctrl_min,
        "max", ctrl_max
      ),
      "t", lexicon(
        "curr", time:seconds,
        "prev", false,//if false, skip calculus-esque comps
        "delta", 0,//if change is zero, skip calculus-esque comps
        "susp_delta", t_susp_delta//if the time change is suspiciously large, skip calculus-esque comps (because game warp/focus)
      ),
      "e", lexicon(
        "d", e_d,
        "p", e_p,
        "i", e_i
      )
    ).
  }

  function seek {
    parameter
      pid,
      seek_value,
      current_value.

    local skip_calculus is false.
    if pid["t"]["prev"] = false {
      set skip_calculus to true.
    }

    //do time things
    set pid["t"]["prev"] to pid["t"]["curr"].
    set pid["t"]["curr"] to time:seconds.
    set pid["t"]["delta"] to
      pid["t"]["curr"] - pid["t"]["prev"].
    if pid["t"]["delta"] > pid["t"]["susp_delta"] {
      set skip_calculus to true.
    }

    //e_p (proportional)
    //raw
    set pid["e"]["p"]["prev"] to pid["e"]["p"]["curr"].
    set pid["e"]["p"]["curr"] to
      max(
        pid["e"]["p"]["min"],
        min(
          pid["e"]["p"]["max"],
          seek_value - current_value ) ).
    set pid["e"]["p"]["delta"] to
      pid["e"]["p"]["curr"] - pid["e"]["p"]["prev"].
    //comp
    set pid["e"]["p"]["comp"]["prev"] to
      pid["e"]["p"]["comp"]["curr"].
    set pid["e"]["p"]["comp"]["curr"] to
      pid["e"]["p"]["curr"] * pid["e"]["p"]["k"].
    set pid["e"]["p"]["comp"]["delta"] to
      pid["e"]["p"]["comp"]["curr"] - pid["e"]["p"]["comp"]["prev"].

    if skip_calculus = false {
      //e_d (derivative)
      //raw
      set pid["e"]["d"]["prev"] to pid["e"]["d"]["curr"].
      set pid["e"]["d"]["curr"] to
        max(
          pid["e"]["d"]["min"],
          min(
            pid["e"]["d"]["max"],
            pid["e"]["p"]["delta"] / pid["t"]["delta"] ) ).// dp/dt
      set pid["e"]["d"]["delta"] to
        pid["e"]["d"]["curr"] - pid["e"]["d"]["prev"].
      //comp
      set pid["e"]["d"]["comp"]["prev"] to
        pid["e"]["d"]["comp"]["curr"].
      set pid["e"]["d"]["comp"]["curr"] to
        pid["e"]["d"]["curr"] * pid["e"]["d"]["k"].
      set pid["e"]["d"]["comp"]["delta"] to
        pid["e"]["d"]["comp"]["curr"] - pid["e"]["d"]["comp"]["prev"].

      //e_i (integral)
      //raw
      set pid["e"]["i"]["prev"] to pid["e"]["i"]["curr"].
      set pid["e"]["i"]["curr"] to
        max(
          pid["e"]["i"]["min"],
          min(
            pid["e"]["i"]["max"],
            pid["e"]["i"]["prev"] + (
              pid["e"]["p"]["curr"] * pid["t"]["delta"] ) ) ).
      set pid["e"]["i"]["delta"] to
        pid["e"]["i"]["curr"] - pid["e"]["i"]["prev"].
      //comp
      set pid["e"]["i"]["comp"]["prev"] to
        pid["e"]["i"]["comp"]["curr"].
      set pid["e"]["i"]["comp"]["curr"] to
        pid["e"]["i"]["curr"] * pid["e"]["i"]["k"].
      set pid["e"]["i"]["comp"]["delta"] to
        pid["e"]["i"]["comp"]["curr"] - pid["e"]["i"]["comp"]["prev"].
    }

    //ctrl
    set pid["ctrl"]["prev"] to pid["ctrl"]["curr"].
    set pid["ctrl"]["curr"] to
      max(
        pid["ctrl"]["min"],
        min(
          pid["ctrl"]["max"],
          pid["e"]["p"]["comp"]["curr"]
        + pid["e"]["i"]["comp"]["curr"]
        + pid["e"]["d"]["comp"]["curr"] ) ).
    set pid["ctrl"]["delta"] to
      pid["ctrl"]["curr"] - pid["ctrl"]["prev"].

    return pid.
  }

  export(lex(
    "version", "0.0.1",
    "comp", comp@,
    "init", init@,
    "seek", seek@
  )).
}
