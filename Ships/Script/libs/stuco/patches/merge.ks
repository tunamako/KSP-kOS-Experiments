// takes a list of lists or a list of lexicons
//(later lexicon keys overwrite earlier ones for conflicts)
function merge {
  parameter list_of_collections.

  if list_of_collections:typename = "list" {

    local merged_collection is list().
    for collection in list_of_collections {
      for element in collection {
        merged_collection:add(element).
      }
    }
  }else if list_of_collections:typename = "lexicon" {

    local merged_collection is lex().
    for collection in list_of_collections {
      for key in collection:keys {
        set merged_collection[key] to collection[key].
      }
    }
  }else{return 1/0}.
  return merged_collection.
}
