/////////////////////////////////////////////////////////////////////////////
// Simple ascend-to-orbit boot script.
/////////////////////////////////////////////////////////////////////////////
// Launch and ascend to a fixed altitude.
//
// MUST NOT be used for vessels that will operate out of comms range!!
/////////////////////////////////////////////////////////////////////////////

switch to archive.

run once lib_ui.

if ship:status = "prelaunch" {
  uiBanner("Mission", "Launch!").
  stage.
  wait 1.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  if (body:name = "Kerbin") {
    uiBanner("Mission", "Ascend to orbit.").
    //     KEO: 2863334.06
    // parking: body:atm:height + (body:radius / 4)
    run launch_asc(body:atm:height + (body:radius / 4)).
  }
  else {
    uiBanner("Mission", "Land on " + body:name + ".").
    run land.
  }
}
