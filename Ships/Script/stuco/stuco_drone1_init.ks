// This file is distributed under the terms of the MIT license, (c) the KSLib team
clearscreen.
lock steering to heading(0, 90).
lock throttle to 1.
stage.

wait until altitude > 100.
lock steering to heading(0, 80).
wait 2.
lock steering to heading(0, 70).
wait 2.
lock steering to heading(0, 60).
wait 2.
lock steering to heading(0, 50).
wait 2.
lock steering to heading(0, 40).
wait 2.
lock steering to heading(0, 30).
wait 2.
lock steering to heading(0, 20).
wait 2.
lock throttle to 0.4.
lock steering to heading(0, 10).

until false {
  wait until altitude > 4000.
  lock steering to heading(0, 0).
  lock throttle to 0.3.
  wait until altitude < 3950.
  lock steering to heading(0, 4).
  wait 1.
}.
