{
  function build {
    parameter
      comps, //list of values with initial guesses
      scorer. //delegate that takes comps and returns a scorer
    return lex(
      "comps", comps,
      "score", -1*10^15,
      "scorer", scorer,
      "seeks", list()
    ).
  }

  function seek {
    parameter scorecard.
    //for each scorecard["comp"], hillclimb it through scorecard["scorer"].
    local comp_i is 0.
    for comp in scorecard["comps"] {
      local stepsize is 1.
      local climbed is false.
      until climbed = true {
        local test_comps is lex(
          "stay", scorecard["comps"],
          "up",   scorecard["comps"],
          "down", scorecard["comps"]
        ).
        set test_comps["up"][comp_i] to test_comps["up"][comp_i] + stepsize.
        set test_comps["down"][comp_i] to test_comps["down"][comp_i] - stepsize.
        local test_scores is lex(
          "stay", scorecard["scorer"](test_comps["stay"]),
          "up",   scorecard["scorer"](test_comps["up"]),
          "down", scorecard["scorer"](test_comps["down"])
        ).
        //test for completion
        if (
          test_scores["stay"] >= test_scores["up"] and
          test_scores["stay"] >= test_scores["down"] and
          stepsize <= 0.00001
        ) {
          set scorecard["comps"] to test_comps["stay"].
          set scorecard["score"] to test_scores["stay"].
          set climbed to true.
        }
        //test for reduction (half) in step stepsize
        else if (
          test_scores["stay"] >= test_scores["up"] and
          test_scores["stay"] >= test_scores["down"] and
          stepsize > 0.01
        ) {
          set scorecard["comps"] to test_comps["stay"].
          set scorecard["score"] to test_scores["stay"].
          set stepsize to stepsize / 2.
        }
        //test for rebase and increase (double) in stepsize
        else if (
          test_scores["up"] > test_scores["stay"] or
          test_scores["down"] > test_scores["stay"]
        ) {
          set stepsize to stepsize * 2.
          if test_scores["up"] > test_scores["down"] {
            set scorecard["comps"] to test_comps["up"].
          } else {
            set scorecard["comps"] to test_comps["down"].
          }
        }
        print test_scores.
        print stepsize + "," + scorecard["comps"][0] + "," + scorecard["score"].//testing
        wait 5.
      }
      set comp_i to comp_i + 1.
    }
    //append a lex of this comps and score to scorecard["seeks"].
    scorecard["seeks"]:add(lex(
      "comps", scorecard["comps"],
      "score", scorecard["score"]
    )).
    //return the scorecard.
    return scorecard.
  }

  export(lex(
    "ver", "0.0.1",
    "seek", seek@,
    "build", build@
  )).
}
