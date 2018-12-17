#' Returns a list of functions assocaited with a stored set of options.
#'
#' @param value The list of possible options.
#'
#' @section Attribution:
#'
#' This code is copied from the code handling options in [knitr].
#'
#' @keywords internal
new_default_options <- function(value = list()) {
  defaults = value

  merge_list = function(x, y) {
    x[names(y)] = y
    x
  }

  get = function(name, default = FALSE, drop = TRUE) {
    if (default) defaults = value  # this is only a local version
    if (missing(name)) defaults else {
      if (drop && length(name) == 1) defaults[[name]] else {
        setNames(defaults[name], name)
      }
    }
  }
  resolve = function(...) {
    dots = list(...)
    if (length(dots) == 0) return()
    if (is.null(names(dots)) && length(dots) == 1 && is.list(dots[[1]]))
      if (length(dots <- dots[[1]]) == 0) return()
    dots
  }
  set = function(...) {
    dots = resolve(...)
    if (length(dots)) defaults <<- merge(dots)
    invisible(NULL)
  }
  merge = function(values) merge_list(defaults, values)
  restore = function(target = value) defaults <<- target
  append = function(...) {
    dots = resolve(...)
    for (i in names(dots)) dots[[i]] <- c(defaults[[i]], dots[[i]])
    if (length(dots)) defaults <<- merge(dots)
    invisible(NULL)
  }

  list(get = get, set = set, append = append, merge = merge, restore = restore)
}


#' Default options
#'
#' The default values for package-wide options.
#'
#' @section Attribution:
#'
#' This code is copied from the code handling options in [knitr].
#'
#' @examples
#'
#' # List all options
#' ref_options$get()
#'
#' # Get a spcific option
#' ref_options$get('config_file_name')
#'
#' # Set one or more options
#' ref_options$set(config_file_name =  ".my_comstom_config.yml")
#'
#' @export
ref_options = new_default_options(list(
  verbose = FALSE,
  config_file_name = ".refmanager.yml",
  local_references = TRUE,
  local_references_dir = "references",
  link_references = TRUE,
  overwrite_references = TRUE
))

