timestamp_filename = function(path, stamp = Sys.time(), position = "end") {

  stamp = gsub(" ", "_", stamp)
  stamp = gsub(":", "-", stamp)

  filename = tools::file_path_sans_ext(
    basename(path)
  )

  if (position == "beg") {
    filename = paste0(stamp, "_", filename)
  } else if (position == "end") {
    filename = paste0(filename, "_", stamp)
  } else {
    stop("`position` must be 'beg' (beginning) or 'end'")
  }

  paste0(
    dirname(path),
    "/",
    filename,
    ".",
    tools::file_ext(path)
  )

}
