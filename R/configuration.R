#' Read a configuration file
#'
#' Read a yaml configuartion file
#'
#' @param file_path The full path to the file to read.
#'
#' @keywords internal
read_config_file <- function(file_path) {
  yaml::read_yaml(file_path)
}


#' Get configuration settings
#'
#' Get settings stored in a configuration file
#'
#' @param dir_path The directory to start the search from. Defaults to current
#'   working directory.
#' @param config_name The name of the configuration file. The default name of the configuration file is defined by the
#'   global constant variable `config_file_name` in [ref_options].
#'
#' @keywords internal
get_config <- function(dir_path = getwd(), config_name = ref_options$get("config_file_name")) {
  config_path <- find_file_in_parent(file_name = config_name, dir_path = dir_path)
  return(read_config_file(config_path))
}


#' Get a configuration setting
#'
#' Get a setting stored in a configuration file
#'
#' @param value The name of the setting to get
#' @param allow_global_default TRUE/FALSE. If TRUE and a value cannot be found
#'   in a configuration file and the same value is a global package option
#'   defined in [ref_options], then use the global pacakge option.
#' @inheritDotParams get_config
#'
#' @keywords internal
get_config_value <- function(value, allow_global_default = TRUE, ...) {
  config <- get_config(...)
  if (value %in% names(config)) {
    return(config[[value]])
  } else if (allow_global_default && value %in% names(ref_options$get())) {
    return(ref_options$get(value))
  } else {
    stop('Cannot find the setting "', value, '" in configuration file.')
  }
}
