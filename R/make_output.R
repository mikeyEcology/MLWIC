#' Present output from a dataset classified by \code{MLWIC}
#'
#' \code{make_output} will make a clean csv presenting the results from your run
#' of \code{classify}.
#'
#' @param output_location Absolute path where you want the output csv stored. This path
#'  must exist on your computer.
#' @param output_name Desired name of the output file
#' @param saved_predictions This is the file name where you stored predictions when you ran
#'  \code{classify}. If you used the default in that function, you can use the default here.
#' @param model_dir Absolute path to the location where you stored the L1 folder
#'  that you downloaded from github.
#' @export
make_output <- function(
  output_location,
  model_dir,
  output_name = "output.csv",
  saved_predictions = "model_predictions.txt"
){
  #- read in text file of model output
  # navigate to directory with trained model
  if(endsWith(model_dir, "/")){
    setwd(paste0(model_dir, "L1"))
  } else {
    setwd(paste0(model_dir, "/L1"))
  }
  out <- utils::read.csv(saved_predictions, header=FALSE)

  # set new column names
  colnames(out) <- c("rowNumber", "fileName", "answer", "guess1", "guess2",  "guess3", "guess4",  "guess5",
                     "confidence1", "confidence2", "confidence3", "confidence4", "confidence5")
  # get rid of [ ]
  out$guess1 <- gsub("[", "", out$guess1, fixed=TRUE)
  out$confidence1 <- gsub("[", "", out$confidence1, fixed=TRUE)
  out$guess5 <- gsub("]", "", out$guess5, fixed=TRUE)
  out$confidence5 <- gsub("]", "", out$confidence5, fixed=TRUE)

  # output
  if(endsWith(output_location, "/")){
    output_full <- paste0(output_location, output_name)
  } else {
    output_full <- paste0(output_location, "/", output_name)
  }
  utils::write.csv(out[,-1], output_full)

  print(paste0("Output can be found here: ", output_full))
}
