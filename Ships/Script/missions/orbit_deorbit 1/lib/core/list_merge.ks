if defined lib = false {global lib is lexicon().}
if lib:haskey("core") = false {set lib["core"] to lexicon().}


set lib["core"]["list_merge"] to {
  parameter lists.// a list of one or more lists to merge

  set base_list to list().
  for sublist in lists {
    for sublist_item in sublist {
      base_list:add(sublist_item).
    }
  }

  return base_list.
}.
