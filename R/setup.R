#' Setup your computer to run \code{MLWIC}
#'
#'
#' \code{setup} installs necessary R packages on your computer. You will
#' need to run this before running \code{classify} and \code{train}. If this is your first time using
#' this function, you should see additional documentation at https://github.com/mikeyEcology/MLWIC .
#' If you follow the link to install Anacoda for Python 2.7, it should be in the default location.
#'
#' @param python_loc The location of python 2.7 on your machine. If you are
#'  using a Macintosh, the default is the likely location.
#'  @param conda_loc The location of conda. It is usually in the same folder as python 2.7
#'
#' @export
setup <- function(
  python_loc = "/anaconda2/bin/python2.7",
  conda_loc = "/anaconda2/bin/conda"
){
  # load reticulate
  #library(devtools)
  #devtools::install_github("reticulate")
  #utils::install.packages("reticulate")
  #library(reticulate)
  reticulate::use_python(python_loc)

  # packages needed for MLWIC
  packs <- c(#"re", "math",
             "numpy", "cycler", "matplotlib", "tornado", #"StringIO", "sys",
             "argparse", #"os",
             "six", "scipy", #"datetime",
             "tensorflow" #, "time"
             )

  #- create a conda environment
  # first remove cconda environment
  reticulate::conda_remove("r-reticulate")
  #reticulate::conda_create("r-reticulate", conda="/anaconda3/bin/conda")
  reticulate::conda_create("r-reticulate", conda=conda_loc)
  #reticulate::conda_install("r-reticulate", packs)

  # install python packages
  reticulate::py_install(packs, conda=conda_loc)

}
