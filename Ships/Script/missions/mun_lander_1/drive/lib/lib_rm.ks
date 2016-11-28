{
  local runmode_filename is "runmode.txt".

  local rm_get is {
    parameter runmode_dir is path():segments:join("/").
    local start_dir is path():segments:join("/").
    local runmode_dir_files is 0.
    local runmode_file is 0.
    cd(runmode_dir).
    list files in runmode_dir_files.
    for item in runmode_dir_files {
      if item:isfile and item:name = runmode_filename {
        set runmode_file to item.
        break.
      }
    }
    cd(start_dir).
    if runmode_file = 0 {return false.}
    return runmode_file:readall():string:trim.
  }.

  local rm_set is {
    parameter
      runmode_content,
      runmode_dir is path():segments:join("/").
    local runmode_path is runmode_dir + "/" + runmode_filename.
    if exists(runmode_path) deletepath(runmode_path).
    log runmode_content to runmode_path.
    return runmode_content.
  }.

  export(lex(
    "ver", "0.0.2",
    "get", rm_get@,
    "set", rm_set@
  )).
}
