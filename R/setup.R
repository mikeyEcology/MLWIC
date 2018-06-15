#' Setup your computer to run \code{MLWIC}
#'
#'
#' \code{setup} installs necessary R packages on your computer. You will
#' need to run this before running \code{classify} and \code{train}.If this is your first time using
#' this function, you should see additional documentation at https://github.com/mikeyEcology/MLWIC .
#'
#' @param python_loc The location of python 2.7 on your machine. If you are
#'  using a Macintosh, the default is the likely location.
#' @export
setup <- function(
  python_loc = "/anaconda2/bin/python"
){
  # load reticulate
  #library(devtools)
  #devtools::install_github("reticulate")
  #utils::install.packages("reticulate")
  #library(reticulate)
  reticulate::use_python(python_loc)

  # packages needed for MLWIC
  packs <- c(#"re", "math",
             "numpy", "cycler", "matplotlib", #"StringIO", "sys",
             "argparse", #"os",
             "six", "scipy", "datetime" #, "time"
             )

  # create a conda environment
  #reticulate::conda_create("r-reticulate")
  #reticulate::conda_install("r-reticulate", packs)

  reticulate::py_install(packs)
}
