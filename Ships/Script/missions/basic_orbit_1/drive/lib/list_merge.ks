{
    local list_merge is {
        parameter lists.// a list of one or more lists to merge

        set base_list to list().
        for sublist in lists {
            for sublist_item in sublist {
              base_list:add(sublist_item).
            }
        }
        return base_list.
    }.
    export(lex(
      "ver", "0.0.1",
      "list_merge", list_merge@
    )).
}
