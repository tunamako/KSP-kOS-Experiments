//common math that's missing from kOS and other useful stuff.
@lazyglobal off.

function near_zero { //useful to catch potential 'divide by zero' cases
  parameter
    i. //some number to check
  return (
    i < stuco["constants"]["smallNumber"]
  ).
}

function vector_project { //projection of a material vector onto a base vector
  parameter
   v1, //material vector
   v0. //base vector

  return (
    (
      vdot(v1, v0) / vdot(v0, v0)
    ) * v0
  ). //projection vector
}
