//kos has the opposite of this already built in: "vxcl".
function vectorproject {
  parameter v1, v2. // project v1 onto the line of v2.
  return v1 - vxcl(v1, v2).
}

function vprj {
  parameter v1, v2.
  return vectorproject(v1, v2).
}
