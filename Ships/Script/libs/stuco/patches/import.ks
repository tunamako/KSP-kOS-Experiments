{
  local import_file is 0.
  local dict is lex().

  global export is {
    parameter exported.
    set dict[import_file] to exported.
  }.

  global import is {
    parameter import_path.

    set import_file to import_path.
    local start_path is "/"+path():segments:join("/").
    local parent_path is "/"+path(import_path):parent:segments:join("/").
    local import_name is import_path:split("/")[import_path:split("/"):length-1].
    cd(parent_path).
    list files in sibling_items.
    cd(start_path).

    local import_is_dir is false. // assume it's a file
    if import_path:endswith("/") {

      set import_is_dir to true.
    }else{

      for item in sibling_items {

        if item:name = import_name and item:isfile = false { // found and is directory
          set import_is_dir to true.
        }
      }
    }
    if import_is_dir = false { // is a file

      runpath(import_path).
      return dict[import_path].
    }else{

      local deep_imports is lex().
      cd(import_path).
      list files in import_items.
      cd(start_path).
      for import_item in import_items {

        local next_import_name is import_item:name.
        if next_import_name:endswith(".ks") {
          set next_import_name to next_import_name:substring(0, next_import_name:length-3).
        }else if next_import_name:endswith(".ksm") {
          set next_import_name to next_import_name:substring(0, next_import_name:length-4).
        }
        local next_import is import_path+"/"+next_import_name.
        set deep_imports[next_import_name] to import(next_import).
      }
      return deep_imports.
    }
  }.
}
