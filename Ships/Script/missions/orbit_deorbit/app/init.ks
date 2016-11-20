if exists("/app/runmode.ks") = false {
  writejson(lexicon("runmode", "main"), "/app/runmode.ks").
}
runoncepath("/app/" + readjson("/app/runmode.ks")["runmode"]).
