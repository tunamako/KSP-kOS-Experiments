@lazyglobal off.
clearscreen.
set ship:control:pilotmainthrottle to 0.
cd("/").
hudtext(
  "Booting...",
  5, 2, 30, white, true).
runoncepath("init.ks").
reboot.
