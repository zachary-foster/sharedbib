#' Find path to bibliography
#'
#' Searchs for the path to the bibliography file by looking for a configuration
#' file in a parent directory.
#'
#' @inheritDotParams get_config
#'
#' @export
bib_path <- function(...) {
  return(path.expand(get_config_value("bib_path", ...)))
}

#' Find path to library
#'
#' Searchs for the path to the library folder containing documents assocaited
#' with bibtex citations in the bibliography by looking for a configuration file
#' in a parent directory.
#'
#' @inheritDotParams get_config
#'
#' @export
library_path <- function(...) {
  return(get_config_value("library_path", ...))
}


#' Get path to document associated with a citation
#'
#' Get the full path to a document (e.g. pdf) associated with a bibtex entry.
#' The document should be named the same as the bibtex key, besides for the file extension
#'
#' @param bibtex_key The bibtex key for the citation and the file name.
#' @inheritDotParams library_path
#'
#' @export
document_path <- function(bibtex_key, ...) {
  lib_path <- library_path(...)

  # Get all files in this directory
  file_paths <- file.path(lib_path, list.files(lib_path, recursive = TRUE))
  file_paths <- file_paths[!file.info(file_paths)$isdir]

  # Look for target file
  matching_files <- file_paths[grepl(tools::file_path_sans_ext(basename(file_paths)), pattern = bibtex_key, fixed = TRUE)]

  # Check that a single file was found
  if (length(matching_files) == 0) {
    stop('Did not find any files matching "', bibtex_key, '"', call. = FALSE)
  } else if (length(matching_files) == 0) {
    warning('Found multiple files matching "', bibtex_key,
            '". Only using the first file, called: "', matching_files[1], '"', call. = FALSE)
    matching_files = matching_files[1]
  }

  return(matching_files)
}


#' Add reference document to project
#'
#' Add a local copy or link to the document referenced by a bibtex key in a folder.
#' The folder the copy of the document is stored in is defined by the option "local_references_dir" in the user's configuration file or in [ref_options].
#'
#' @param bibtex_key The bibtex key for the citation and the file name.
#' @param overwrite_references TRUE/FALSE. If TRUE, overwrite existing reference documents.
#' @param link_references TRUE/FALSE. If TRUE, make a link to the document in the library. If FALSE, copy the document.
#' @param local_references_dir A relative path to where to store the file. If the directory does not already exist it will be created.
#' @inheritDotParams library_path
#'
#' @export
add_document <- function(bibtex_key, overwrite_references = get_config_value("overwrite_references"), link_references = get_config_value("link_references"), local_references_dir = get_config_value("local_references_dir"), ...) {
  doc_path <- document_path(bibtex_key, ...)
  if (local_references_dir == "") {
    copy_path <- basename(doc_path)
  } else {
    copy_path <- file.path(local_references_dir, basename(doc_path))
    if (! dir.exists(local_references_dir)) {
      dir.create(local_references_dir, recursive = TRUE)
    }
  }
  if (link_references) {
    if (overwrite_references && (!is.na(Sys.readlink(copy_path)) || file.exists(copy_path))) {
      file.remove(copy_path)
    }
    R.utils::createLink(link = copy_path, target = doc_path, overwrite = overwrite_references)
  } else {
    file.copy(doc_path, copy_path, overwrite = overwrite_references)
  }

  return(invisible(copy_path))
}


#' Link a reference document in R markdown
#'
#' Add a link to a local copy or link to the document referenced by a bibtex
#' key. The folder the copy of the document is stored in is defined by the
#' option "local_references_dir" in the user's configuration file or in
#' [ref_options].
#'
#' @param bibtex_key The bibtex key for the citation and the file name.
#' @param link_text The text that will be shown and can be clicked on. By
#'   default, text is made from information in the bibtex file.
#' @param local_references TRUE/FALSE. If TRUE, then a copy/link of the document
#'   is added in a folder in the current working directory. See [add_document]
#'   for details. If FALSE, the document in the users' library is linked to.
#' @inheritDotParams add_document
#'
#' @export
link_document <- function(bibtex_key, link_text = NULL, local_references = get_config_value("local_references"), ...) {
  if (local_references) {
    doc_path <- add_document(bibtex_key, ...)
  } else {
    doc_path <- document_path(bibtex_key, ...)
  }
  if (is.null(link_text)) {
    link_text <- basename(doc_path)
  }
  paste0("[", link_text, "](", doc_path, ")")
}

