{
  local import_file is 0.
  local dict is lex().

  global import is {
    parameter filepath.
    set import_file to filepath.
    runpath(filepath).
    return dict[filepath].
  }.

  global export is {
    parameter file_export.
    set dict[import_file] to file_export.
  }.
}
