
<!-- README.md is generated from README.Rmd. Please edit that file -->
refmanager
==========

This is an R package to help using a single BibTeX file in multiple places throughout a file system without relying on a static directory structure. This allows you to use a single BibTeX file and document library (e.g. a directory with PDFs) for all R markdown documents in directory and their sub directories, even if the directory or its sub directories are moved/renamed. It also helps linking and organizing PDFs (or other documents) associated with a citation, so you can have a single location for all PDFs. Its intended use is taking notes in R markdown.

Defining a shared bibtex file
-----------------------------

The BibTeX file and document library (e.g. a directory with PDFs) is specified per-directory using a configuration file. The configuration file will also automatically apply to all sub directories. By default, the configuration file is called .refmanager.yml. Here is an example of a possible configuration file:

    bib_path: "~/files/library/references.bib"
    library_path: "~/files/library"
    local_references: TRUE
    local_references_dir: "references" 
    link_references: TRUE
    overwrite_references: TRUE

You can then use the following code in your R markdown YAML header to use the BibTeX file specified in the configuration file:

`` bibliography: "`r refmanager::bib_path()`" ``

When the R markdown document is rendered, `refmanager` will search all parent directories for a .refmanager.yml file and use the data there to find the path to the BibTeX file. Therefore, the R markdown document or the directory it is in can be moved/renamed without having to change the YAML header.

Linking documents assocaited with a citation
--------------------------------------------

`refmanager` can also help with linking the PDFs (or other formats) that a citation references to the R markdown document. This assumes you have a copy of the document on your computer and the document is named by the BibTeX key associated with it. For example, if you have the following BibTeX entry:

    @article{teng2018plant,
      title={Plant-Derived Exosomal MicroRNAs Shape the Gut Microbiota},
      author={Teng, Yun and Ren, Yi and Sayed, Mohammed and Hu, Xin and Lei, Chao and Kumar, Anil and Hutchins, Elizabeth and Mu, Jingyao and Deng, Zhongbin and Luo, Chao and others},
      journal={Cell Host \& Microbe},
      year={2018},
      publisher={Elsevier}
    }

The associated document would have to be called "teng2018plant.pdf". The file extension is ignored, so it could also be called "teng2018plant.docx" for example. All such documents must be in a directory defined by the `library_path` option or one of its sub directories.

You can then link a document in an R markdown file using `link_document("teng2018plant")`. This will save a local copy of the document in the current working directory (where the R markdown file is) and create a clickable link to the local copy. This allows your notes to be portable while still using a single location for the BibTeX file and associated PDFs.

Options
-------

There are three ways to specify options for the functions in `refmanager`, in order of precedence:

-   The function parameters. E.g. `link_document("teng2018plant", local_references = TRUE)`
-   The package settings. E.g. `ref_options$set(local_references = TRUE)` added to a chunk in the R markdown document.
-   The configuration file. E.g. `local_references: TRUE` in a file called .refmanager.yml in a parent directory.

If none of these are used, then the value for the options can be found using `ref_options$get()`.

Below is are the descriptions of available options:

### bib\_path

The path to the BibTeX file to use. This can only be set using a configuration file or function argument.

### library\_path

The path to a directory with documents associated with entries in the BibTeX file. The documents can be in sub directories and the names/structure of the sub directories does not matter. This can only be set using a configuration file or function argument.

### config\_file\_name

The name of the configuration file used. Its probably best to use the default unless you have a good reason not to.

Default: .refmanager.yml

### local\_references

TRUE/FALSE. When linking documents, should a copy of the document be added to the current working directory (where the R markdown file is)? If `FALSE`, then the document in the library will be linked to. If `TRUE`, the copy will be linked to.

Default: TRUE

### local\_references\_dir

Where the copies of documents are stored, relative to the current working directory (where the R markdown file is). Setting this to `""` will cause the files to be copied to the current working directory.

Default: references

### link\_references

TRUE/FALSE. When linking documents, should a copy of the document made or a link to the original document be added? If `TRUE`, on Linux/IOS a symbolic link is used; on Windows, a shortcut is used.

Default: TRUE

### overwrite\_references

TRUE/FALSE. When linking documents, should an existing copy/link be overwritten?

Default: TRUE

Comments and contributions
--------------------------

I welcome comments, criticisms, and especially contributions! GitHub issues are the preferred way to report bugs, ask questions, or request new features. You can submit issues here:

<https://github.com/zachary-foster/refmanager/issues>
