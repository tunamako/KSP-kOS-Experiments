//wip

//This library makes heavy use of the inertial reference frame of the
//celestial body being orbited. However, there is good reason to believe that
//the developers of kOS as well as the wiki authors have no idea what the
//inertial reference frame is; they can be seen bitching about "wandering x and
//z coordinates". But I believe the cartesian coordinate system of KSP is
//in fact the proper inertial reference frame for the celestial body, so it will
//be used as the basis when calculating orbital parameters such as Keplerian
//elements.
@lazyglobal off.

set constant:smallNumber to 0.001.

function angular_momentum_vector {
  parameter
    p0,//position coordinates (celestial body's inertial reference frame)
    v0.//velocity vector (celestial body's inertial reference frame)
  return vcrs(p0, v0).
}

function node_vector {
  parameter
    p0,
    v0.
  return vcrs(
    v(0,0,1),
    angular_momentum_vector(p0, v0)
  ).
}

function eccentricity_vector {
  parameter
    p0,
    v0,
    mu0.//celesatial body's gravitational parameter
  return (
    (
      (
        (
          (
            v0:mag ^ 2
          ) - (
            mu0 / p0:mag
          )
        ) * p0
      ) - (
        vdot(p0, v0) * v0
      )
    ) / mu0
  ).
}

function specific_mechanical_energy {
  parameter
    p0,
    v0,
    mu0.
  return (
    (
      v0:mag ^ 2
    ) / 2
  ) - (
    mu0 / p0:mag
  ).
}

function semimajor_axis {
  parameter
    p0,
    v0,
    mu0.
  if eccentricity_vector(p0, v0, mu0):mag - 1 < stuco["constants"]["smallNumber"] {

  }
}

function state_vectors_to_orbital_elements {
  parameter
    p0,
    v0,
    mu0.
  local orbit
}
