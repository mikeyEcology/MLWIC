#' Evaluate images using the trained model
#'
#' \code{MLWIC_eval} Uses the Species Level model from Tabak et al. (the built in model) to predict
#' the species in each image. If you trained a model using \code{MLWIC_train},
#' this function can also be used to evalute images using the model developed by
#' \code{MLWIC_train} by specifying the \code{log_dir} of the trained model.
#'
#' @param path_prefix Absolute path to location of the images on your computer (or computing cluster).
#'  All images must be stored in one folder.
#' @param data_info Name of a csv containing the file names of each image.
#'  This file must have only two columns and NO HEADERS. The first column must be the file name of the image
#'  The second column can be the number corresponding to the species or group in the image.
#'  See Table 1 in Tabak et al. for the numbers (if using the built in model. If you do not know the species in the image,
#'  put a zero in each row of column 2.
#' @param save_predictions File name where model predictions will be stored.
#'  You should not need to change this parameter.
#'  After running this function, you will run \code{MLWIC_make_output} to
#'  make the output in a more viewer friendly format
#' @param python_loc The location of python 2.7 on your machine. If you are
#'  using a Macintosh, the default is the likely location
#' @param num_classes The number of classes in your model. If you are using
#'  the Species Level model from Tabak et al., the number is `28`.
#' @param delimiter this will be a `,` for a csv.
#' @param log_dir If you trained a model with \code{MLWIC_train}, this
#'  will be the log_directory that you specified when using that function.
#'  If you are using the built in model, the default is appropriate.
#' @param model_dir Absolute path to the location where you stored the L1 folder
#'  that you downloaded from github.
#' @export
MLWIC_eval <- function(
  # set up some parameters for function
  path_prefix , # absolute path to location of the images on your computer
  data_info, # csv with file names for each photo. See details
  model_dir,
  save_predictions = "model_predictions.txt", # txt file where you want model output to go
  python_loc = "/anaconda2/bin/", # location of the python that Anacnoda uses on your machine
  num_classes = 28, # number of classes in model
  delimiter = ",", # this will be , for a csv.
  log_dir = "USDA182"

){
  # navigate to directory with trained model
  if(endsWith(model_dir, "/")){
    setwd(paste0(model_dir, "L1"))
  } else {
    setwd(paste0(model_dir, "/L1"))
  }

  # load in data_info and store it in the model_dir
  labels <- utils::read.csv(data_info, header=FALSE)
  utils::write.csv(labels, "data_info.csv", row.names=FALSE)


  # set up code
  eval_py <- paste0(python_loc,
                    "python2.7 eval.py --architecture resnet --depth 18 --log_dir ", log_dir,
                    " --path_prefix ", path_prefix,
                    " --batch_size 128 --data_info data_info.csv",
                    " --delimiter ", delimiter,
                    " --save_predictions ", save_predictions,
                    " --num_classes=", num_classes, "\n")

  # run code
  toc <- Sys.time()
  system(eval_py)
  tic <- Sys.time()
  runtime <- tic-toc

  # end function
  txt <- paste0("evaluation of images took ", runtime, ". ",
                "The results are stored in ", model_dir, "/", save_predictions, ". ",
                "To view the results in a viewer-friendly format, please use the function
                MLWIC_make_output")
  print(txt)

}

#MLWIC_eval(path_prefix="/Users/mikeytabak/Desktop/APHIS/mtMoran_projects/MLWIC/Brook_Images", data_info="Brook_images.csv",
#            save_predictions = "model_predictions_Brook_images.txt")
