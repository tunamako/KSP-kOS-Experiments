{
  function logistic {// https://en.wikipedia.org/wiki/Logistic_function
    parameter
      L is 1,
      k is 1,
      x0 is 0.

    return {
      parameter x.
      local u is -k * (x - x0).
      if u > 500 {return 0.}//catch for an infinity error
      return L / (1 + constant:e ^ u).
    }.
  }

  function exponential {
    parameter
      coeff is 1,
      base is constant:e,
      multiplier is 1.

    return {
      parameter x.
      return coeff * (base ^ (multiplier * x)).
    }.
  }

  //common instances of these equations as alises
  function decay {return exponential(1, constant:e, (-1)).} // common domain [0,inf), range [1,0) descending. good for making hills!

  export(lex(
    "ver", "0.0.1",
    "logistic", logistic@,
    "exponential", exponential@,
    //aliases
    "decay", decay@
  )).
}
