#' Train a machine learning model to classify images
#'
#' \code{train} allows users to train their own machine learning model using images
#' that have been manually classified. We recommend having at least 2,000 images per species,
#' but accuracies will be higher with > 10,000 images. This model will take a very long
#' time to run. We recommend using a GPU if possible. In the \code{data_info} csv, you must
#' have two columns with NO HEADERS. Column 1 must be the file name of the image. Column 2
#' must be a number corresponding to the species. Give each species (or group of species) a
#' number identifying it. The first species must be 0, the next species 1, and so on. If this is your first time using
#' this function, you should see additional documentation at https://github.com/mikeyEcology/MLWIC .
#' This function uses absolute paths, but if you are unfamilliar with this
#' process, you can put all of your images, the image label csv ("data_info") and the L1 folder that you
#' downloaded following the directions at https://github.com/mikeyEcology/MLWIC into one directory on
#' your computer. Then set your working directory to this location and the function will find the
#' absolute paths for you.
#'
#' @param path_prefix Absolute path to location of the images on your computer
#' @param data_info csv with file names for each photo (absolute path to file). This file must have no headers (column names).
#'  column 1 must be the file name of each image including the extention (i.e., .jpg). Column 2
#'  must be a number corresponding to the species. Give each species (or group of species) a
#'  number identifying it. The first species must be 0, the next species 1, and so on.
#' @param python_loc The location of python 2.7 on your machine. If you are
#'  using a Macintosh, the default is the likely location
#' @param num_gpus The number of GPUs available. If you are using a CPU, leave this as default.
#' @param num_classes The number of classes (species or groups of species) in your model.
#' @param delimiter this will be a `,` for a csv.
#' @param model_dir Absolute path to the location where you stored the L1 folder
#'  that you downloaded from github.
#' @param log_dir_train directory where you will store the model information.
#'  This will be called when you what you specify in the \code{log_dir} option of the
#'  \code{classify} function. You will want to use unique names if you are training
#'  multiple models on your computer; otherwise they will be over-written.
#' @export
train <- function(
  # set up some parameters for function
  path_prefix = paste0(getwd(), "/images"), # absolute path to location of the images on your computer
  data_info = paste0(getwd(), "/image_labels.csv"), # csv with file names for each photo. See details
  model_dir = getwd(),
  python_loc = "/anaconda2/bin/", # location of python 2.7 on your machine
  num_gpus = 2,
  num_classes = 28, # number of classes in model
  delimiter = ",", # this will be , for a csv.
  log_dir_train = "train_output"
) {

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
  # labels <- utils::read.csv(data_info, header=FALSE)
  # utils::write.csv(labels, "data_info_train.csv", row.names=FALSE)

  cpfile <- paste0("cp ", data_info, " ", wd, "/data_info_train.csv")
  system(cpfile)

  train_py <- paste0(python_loc,
                     "python2.7 train.py --architecture resnet --depth 18",
                     " --path_prefix ", path_prefix,
                     " --num_gpus ", num_gpus,
                     " --batch_size 128 --data_info data_info_train.csv",
                     " --delimiter ", delimiter,
                     " --retrain_from USDA182 --num_classes ", num_classes,
                     " --log_dir ", log_dir_train)

  # run code
  toc <- Sys.time()
  system(train_py)
  tic <- Sys.time()
  runtime <- tic-toc

  # end function
  txt <- paste0("training of images took ", runtime, ". ",
                "The trained model is in ", log_dir_train, ". ",
                "specify this directory as the log_dir when you use classify(). ")
  print(txt)
}

# train(path_prefix = "/Users/mikeytabak/Desktop/APHIS/mtMoran_projects/MLWIC_dir/MLWIC_package/MLWIC_examples/MLWIC_examples/test_images",
#       data_info = "/Users/mikeytabak/Desktop/APHIS/mtMoran_projects/MLWIC_dir/MLWIC_package/MLWIC_examples/MLWIC_examples/image_labels.csv",
#       model_dir = "/Users/mikeytabak/Desktop",
#       python_loc = "/anaconda2/bin/python2.7")
