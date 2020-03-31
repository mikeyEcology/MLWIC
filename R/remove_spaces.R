#' Remove spaces from all files within a directory
#'
#' \code{remove_spaces} removes paces from file names, which is required to 
#' run MLWIC2 functions on these images. In the future, it is good practice to 
#' avoid putting spaces in any folder or file name. 
#' 
#' @param path The path to the image files whose names need to be changed. The default
#'  is to use your current working directory.
#' @param pattern A vector containing the file name suffixes for which you want to
#'  change the name.
#' @param copy logical. If TRUE, the function will create new files with spaces absent from 
#'  the name. If FALSE, the function will delete the orginial files and create new files without spaces in names.
#'  If FALSE, you are deleting your original files, but saving storage space on your drive.
#' @export 
remove_spaces <- function(
  path = getwd(),
  pattern = c(".JPG", ".jpg"),
  copy=FALSE
){
  filist <- setdiff(list.files(path=path, pattern=paste0(pattern1, collapse="|")),
                    list.dirs(path=path, recursive = FALSE, full.names = FALSE))
  # elements that have spaces in file names
  names_w_spaces <- which(grepl(" ", filist))
  if(length(names_w_spaces) == 0){
    stop("There are no file names with spaces in this directory")
  }
  # make a file list without spaces
  filist_ns <- gsub(" ", "_", filist, fixed=TRUE)
  # create only files where the originals didn't have spaces
  file.create(filist_ns[names_w_spaces])
  # move them
  if(copy){
    file.copy(filist[names_w_spaces], filist_ns[names_w_spaces], overwrite=TRUE)
  } else {
    file.rename(filist[names_w_spaces], filist_ns[names_w_spaces])
  }

}
