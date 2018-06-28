#' Classify images using the trained model
#'
#' \code{classify} Uses the Species Level model from Tabak et al. (the built in model) to predict
#' the species in each image. This function uses absolute paths, but if you are unfamilliar with this
#' process, you can put all of your images, the image label csv ("data_info") and the L1 folder that you
#' downloaded following the directions at https://github.com/mikeyEcology/MLWIC into one directory on
#' your computer. Then set your working directory to this location and the function will find the
#' absolute paths for you.
#' If you trained a model using \code{train},
#' this function can also be used to evalute images using the model developed by
#' \code{train} by specifying the \code{log_dir} of the trained model. If this is your first time using
#' this function, you should see additional documentation at https://github.com/mikeyEcology/MLWIC .
#'
#' @param path_prefix Absolute path to location of the images on your computer (or computing cluster).
#'  All images must be stored in one folder.
#' @param data_info Name of a csv containing the file names of each image (including absolute path).
#'  This file must have Unix linebreaks!
#'  This file must have only two columns and NO HEADERS. The first column must be the file name of the image
#'  The second column can be the number corresponding to the species or group in the image.
#'  See Table 1 in Tabak et al. for the numbers (if using the built in model. If you do not know the species in the image,
#'  put a zero in each row of column 2.
#' @param save_predictions File name where model predictions will be stored.
#'  You should not need to change this parameter.
#'  After running this function, you will run \code{make_output} to
#'  make the output in a more viewer friendly format
#' @param python_loc The location of python 2.7 on your machine. If you are
#'  using a Macintosh, the default is the likely location
#' @param num_classes The number of classes in your model. If you are using
#'  the Species Level model from Tabak et al., the number is `28`.
#' @param delimiter this will be a `,` for a csv.
#' @param log_dir If you trained a model with \code{train}, this
#'  will be the log_directory that you specified when using that function.
#'  If you are using the built in model, the default is appropriate.
#' @param model_dir Absolute path to the location where you stored the L1 folder
#'  that you downloaded from github.
#' @export
classify <- function(
  path_prefix = paste0(getwd(), "/images"), # absolute path to location of the images on your computer
  data_info = paste0(getwd(), "/image_labels.csv"), # csv with file names for each photo. See details
  model_dir = getwd(),
  save_predictions = "model_predictions.txt", # txt file where you want model output to go
  python_loc = "/anaconda2/bin/", # location of the python that Anacnoda uses on your machine
  num_classes = 28, # number of classes in model
  delimiter = ",", # this will be , for a csv.
  log_dir = "USDA182"

){
  wd1 <- getwd() # the starting working directory

  # set these parameters before changing directory
  path_prefix = path_prefix
  data_info = data_info
  model_dir = model_dir

  # navigate to directory with trained model
  if(endsWith(model_dir, "/")){
    setwd(paste0(model_dir, "L1"))
  } else {
    setwd(paste0(model_dir, "/L1"))
  }
  wd <- getwd()

  # load in data_info and store it in the model_dir
  # lbls <- utils::read.csv(data_info, header=FALSE)
  # lbls[,1] <- as.character(lbls[,1])
  # utils::write.table(lbls, "data_info.csv", sep=",",
  #                    row.names=FALSE, col.names=FALSE)
  #file.copy(from=data_info, to=paste0(wd, "/data_info.csv"), header=FALSE)

  cpfile <- paste0("cp ", data_info, " ", wd, "/data_info.csv")
  system(cpfile)


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
                "The results are stored in ", model_dir, "/L1/", save_predictions, ". ",
                "To view the results in a viewer-friendly format, please use the function make_output")
  print(txt)

  # return to previous working directory
  setwd(wd1)

}

