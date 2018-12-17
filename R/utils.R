#' Find file in a parent directory
#'
#' Search all parent directories of a given directory and return the path to the
#' first file found with a given name.
#'
#' @param file_name The name of the file.
#' @param dir_path The directory to start the search from. Defaults to current
#'   working directory.
#' @param regex TRUE/FALSE. Is the `file_name` option a regular expression?
#'
#' @keywords internal
find_file_in_parent <- function(file_name, dir_path = getwd(), regex = FALSE) {
  matching_files <- character(0)

  for (path in parent_dir_paths(dir_path)) {

    # Get all files in this directory
    file_paths <- list.files(path, recursive = FALSE, full.names = TRUE, all.files = TRUE)
    file_paths[!file.info(file_paths)$isdir]

    # Look for target file
    matching_files <- file_paths[grepl(basename(file_paths), pattern = file_name, fixed = !regex)]
    if (length(matching_files) > 0) {
      break()
    }

  }

  # Check that a single file was found
  if (length(matching_files) == 0) {
    stop('Did not find any files matching "', file_name, '"', call. = FALSE)
  } else if (length(matching_files) == 0) {
    warning('Found multiple files matching "', file_name,
            '". Only using the first file, called: "', matching_files[1], '"', call. = FALSE)
    matching_files = matching_files[1]
  }

  return(matching_files)
}



#' Get paths to all parent directories
#'
#' Returns a vector with the full paths to all parent directories of a directory.
#'
#' @param dir_path The directory to start the search from. Defaults to current
#'   working directory.
#'
#' @keywords internal
parent_dir_paths <- function(dir_path = getwd()) {
  parent_path <- dirname(dir_path)
  if (parent_path == dir_path) { # If the root is reached
    return(parent_path)
  } else {
    return(c(dir_path, parent_dir_paths(parent_path)))
  }
}

