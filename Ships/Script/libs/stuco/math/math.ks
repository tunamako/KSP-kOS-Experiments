{
  function similar {
    parameter a, b, tolerance.
    return abs(a - b) <= tolerance.
  }

  export(lex(
    "ver", "0.0.1",
    "similar", similar@
  )).
}
