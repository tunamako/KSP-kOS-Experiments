//climbs are structured in a sequence of one-dimensional hills.

//special hill configurations:
//1: loop sibling hill(s) (used for solo hills as well)
//    used for hills that share the same dimension in the problem space. normally more efficient than sequencing them
//    example: node_time and node_prograde for coplanar hohmann transfers
//2: constrained guess hill
//    used for hills where the initial guess must be defined by the previous hill in the sequence
//    example: alt_hill seeking periapse of a future patch requires that patch to exist, or else returns 0.
{
  local math is import("/libs/stuco/math").

  function climb {
    //hill climb can precede 1 of 4 states:
    //1:  up and double-jump
    //2:  down and double-jump
    //3:  stay and half jump up
    //4:  stay and half jump down
    //closure is checked at each half jump.
    parameter
      _hill, // a function that returns true on success, or a numeric score otherwise. given a guess and a step size
      guess is 0, // a vector of controls
      step is 1, // the initial step to take up and down in the search space.
      max_error is 0.0001. // the step size at which to stop climbing further.

    //first phase: find and jump the peak
    local trials is list(//guess:score pairs
      list(guess-step, _hill(guess-step)),
      list(guess,      _hill(guess)),
      list(guess+step, _hill(guess+step))
    ).
    until false {
      if trials[0][1] <= trials[1][1] and trials[1][1] >= trials[2][1] {//peak is contained!
        break.
      }else if trials[0][1] >= trials[1][1] { // peak is lower; shift downwards and step faster
        set step to step * 2.
        set trials to list(
          list(trials[0][0]-step, _hill(trials[0][0]-step)),
          trials[0],
          trials[1]
        ).
      }else{ // trials[2][1] >= trials[1][1]. peak is higher; shift upwards and step faster
        set step to step * 2.
        set trials to list(
          trials[1],
          trials[2],
          list(trials[2][0]+step, _hill(trials[2][0]+step))
        ).
      }
    }

    //second phase: binary search the contained range for the peak
    until false {

      set trials to list( // add midpoints for hill slope measuring
        trials[0],
        list((trials[0][0]+trials[1][0])/2, _hill((trials[0][0]+trials[1][0])/2)),
        trials[1],
        list((trials[1][0]+trials[2][0])/2, _hill((trials[1][0]+trials[2][0])/2)),
        trials[2]
      ).
      if trials[1][1] <= trials[2][1] and trials[2][1] >= trials[3][1] { // the middle doesn't move
        set trials to trials:sublist(1,3).
      }else if trials[1][1] >= trials[3][1]{ // peak is more likely in the lower half
        set trials to trials:sublist(0,3).
      }else{ // peak is more likely in the upper half
        set trials to trials:sublist(2,3).
      }
      if trials[2][0] - trials[0][0] <= max_error {break.}//check for completion
    }
    return trials[1][0].
  }

  function climb_vec {
    //hill climb can precede 1 of 4 states:
    //1:  up and double-jump
    //2:  down and double-jump
    //3:  stay and half jump up
    //4:  stay and half jump down
    //closure is checked at each half jump.
    parameter
      _vec_hill, // a function that returns true on success, or a numeric score otherwise. given a guess and a step size
      controls,
      index,
      guess is 0, // a vector of controls
      step is 1, // the initial step to take up and down in the search space.
      max_error is 0.0001. // the step size at which to stop climbing further.

    local _hill is {
      parameter guess.

      set controls[index] to guess.
      return _vec_hill(controls).
    }.

    //first phase: find and jump the peak
    local trials is list(//guess:score pairs
      list(guess-step, _hill(guess-step)),
      list(guess,      _hill(guess)),
      list(guess+step, _hill(guess+step))
    ).
    until false {
      if trials[0][1] <= trials[1][1] and trials[1][1] >= trials[2][1] {//peak is contained!
        break.
      }else if trials[0][1] >= trials[1][1] { // peak is lower; shift downwards and step faster
        set step to step * 2.
        set trials to list(
          list(trials[0][0]-step, _hill(trials[0][0]-step)),
          trials[0],
          trials[1]
        ).
      }else{ // trials[2][1] >= trials[1][1]. peak is higher; shift upwards and step faster
        set step to step * 2.
        set trials to list(
          trials[1],
          trials[2],
          list(trials[2][0]+step, _hill(trials[2][0]+step))
        ).
      }
    }

    //second phase: binary search the contained range for the peak
    until false {

      set trials to list( // add midpoints for hill slope measuring
        trials[0],
        list((trials[0][0]+trials[1][0])/2, _hill((trials[0][0]+trials[1][0])/2)),
        trials[1],
        list((trials[1][0]+trials[2][0])/2, _hill((trials[1][0]+trials[2][0])/2)),
        trials[2]
      ).
      if trials[1][1] <= trials[2][1] and trials[2][1] >= trials[3][1] { // the middle doesn't move
        set trials to trials:sublist(1,3).
      }else if trials[1][1] >= trials[3][1]{ // peak is more likely in the lower half
        set trials to trials:sublist(0,3).
      }else{ // peak is more likely in the upper half
        set trials to trials:sublist(2,3).
      }
      if trials[2][0] - trials[0][0] <= max_error {break.}//check for completion
    }
    set controls[index] to trials[1][0].
    return controls.
  }



  export(lex(
    "ver", "0.0.4",
    "climb", climb@, // the actual climbing routine
    "climb_vec", climb_vec@ // same as climb, but on an element of a vector
  )).
}
