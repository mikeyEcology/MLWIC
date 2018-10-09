#' Setup your computer to run \code{MLWIC}
#'
#'
#' \code{setup} installs necessary R packages on your computer. You will
#' need to run this before running \code{classify} and \code{train}. If this is your first time using
#' this function, you should see additional documentation at https://github.com/mikeyEcology/MLWIC .
#' If you follow the link to install Anacoda and you are using a Mac, it should be in the default location.
#'
#' @param python_loc The location of python on your machine. If you are
#'  using a Macintosh, the default is the likely location.
#' @param conda_loc The location of conda. It is usually in the same folder as python
#' @param r_reticulate Logical. Do you have an environment called "r-reticulate" for which you have
#'  installed Python packages previously and want to retain these packages. Default is FALSE.
#'
#' @export
setup <- function(
  python_loc = "/anaconda2/bin/python",
  conda_loc = "auto", #"/anaconda2/bin/conda",
  r_reticulate = FALSE
){
  # load reticulate
  reticulate::use_python(python_loc)

  # packages needed for MLWIC
  packs <- c(#"re", "math",
             "numpy", "cycler", "matplotlib", "tornado", #"StringIO", "sys",
             "argparse", #"os",
             "six", "scipy", #"datetime",
             "tensorflow" #, "time"
             )

  #- create a conda environment if it doesn't already exist
  if(!r_reticulate){
    # first remove conda environment
    reticulate::conda_remove("r-reticulate")
    # then create it
    reticulate::conda_create("r-reticulate", conda=conda_loc)
  }

  # install python packages
  reticulate::py_install(packs, conda=conda_loc)

}
