@lazyglobal off.
set ship:control:pilotmainthrottle to 0.
gear off.
set terminal:charwidth to 6.
set terminal:width to 96.
set terminal:height to 24.

print "initialize app.".
runoncepath("/app/init").
print "boot.ks completed.".
