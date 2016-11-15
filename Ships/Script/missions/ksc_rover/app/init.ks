if exists("/app/runmode.ks") = false {
  writejson(lexicon("runmode", "drive_to"), "/app/runmode.ks").
}
runoncepath("/app/" + readjson("/app/runmode.ks")["runmode"]).
