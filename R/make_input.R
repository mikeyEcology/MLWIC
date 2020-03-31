#' Create an input file to run \code{classify} or \code{train} in \code{MLWIC}
#'
#' \code{make_input} will make a csv with the specifications necessary to either classify 
#' images or to train a new model. If you are using the `find_file_names` option, you
#' only need to specify the `path_prefix` where all of your images are located and this
#' function will generate a file to use with `classify`. Otherwise, you must provide an 
#' `input_file` which contains columns called "filename". If you are using images that have 
#' been classified and you want to evaluate how the model works on these images, set 
#' `images_classified=TRUE` and your `input_file`` must also contain a column called "species", 
#' which contains each image's classification.
#' 
#' @param input_file The name of your input csv. It must contain a column called "filename"
#'  and unless you are using the built in model, a column called "class" (which would be your species or group of species).
#' @param find_file_names logical. If TRUE, this function will find all image files within a 
#'  specified directory. You must specify the directory (`path_prefix`) for this to work.
#'  If you already have a spreadsheet (eg. a `.csv`) with the names of files and their classifications,
#'  this is not the option for you. 
#' @param path_prefix Path to where your images are stored. You need to specify this if 
#'  you want MLWIC2 to `find_file_names`. 
#' @param image_file_suffixes The suffix for your image files. Only specify this if you are 
#'  using the `find_file_names` option. The default is .jpg files. This is case-sensitive.
#' @param recursive logical. Only necessary if you are using the `find_file_names` option. 
#'  If TRUE, the function will find all relevant image files in all subdirectories from the 
#'  path you specify. If FALSE, it will only find images in the folder that you provide as your 
#'  `path_prefix`.
#' @param usingBuiltIn logical. If TRUE, you are setting up a data file to classify images using
#'  the built in model. 
#' @param images_classified logical. If TRUE, you have classifications to go along with these images
#'  (and you want to test how the model performs on these images).
#' @param directory Directory of your input csv. The default option is your working directory.
#'  The file created by this function will be stored in this same directory. 
#' @param trainTest logical. Do you want to create separate csvs for training and testing
#' @param file_prefix What you want to appear as the filename before the suffix. If you are
#'  only creating a file to test the model, you could specify "test_" and your output file name
#'  would be "test_image_labels.csv". If you specify `trainTest = TRUE`, your suffixes will automatically be
#'  "_train.csv" and "_test.csv"
#' @param propTrain proportion of images you want for training. `1-propTrain` is the proportion
#'  that will be used for testing the model. 
#' @export

make_input <- function(
  input_file = paste0(getwd(), "input_file.csv"),
  find_file_names = FALSE,
  path_prefix = getwd(),
  image_file_suffixes = c(".jpg", ".JPG"),
  recursive = TRUE,
  usingBuiltIn = TRUE, 
  images_classified = FALSE,
  trainTest = FALSE, 
  file_prefix = "",
  propTrain = 0.9, 
  directory = getwd()
){
  
  # 
  if(usingBuiltIn == TRUE & trainTest == TRUE){
    stop("You have specified trainTest == TRUE and usingBuiltIn == TRUE. \n
         This does not make sense because you do not want to make separate train and \n
         test files if you are using the built in model.")
  }
  if(trainTest==TRUE & images_classified == FALSE){
    stop("You have specified trainTest == TRUE and images_classified == FALSE. \n
         This does not make sense because you cannot train a model if you do not \n
         have classified images.")
  }
  if(find_file_names == TRUE & images_classified == TRUE){
    stop("You have specified find_file_names==TRUE and images_classified==TRUE. \n
         When MLWIC2 executes the find_file_names option it cannot accept image \n
         classifications associated with each image. If you want to supply \n
         image classifications, you need to supply an input_file. ")
  }
  if(find_file_names == TRUE & is.null(path_prefix)){
    stop("You have specified find_file_names==TRUE and but you have not specified the \n
         directory where your image files are located on your computer.")
  }
  
  # make input file using only the path
  
  if(find_file_names){
    # make a pattern argument for list_files because it cannot take a vector
    pattern <- paste0(image_file_suffixes, collapse="|")
    
    # find file names in directory
    file_names <- list.files(path = path_prefix,  
                             pattern=pattern,
                             full.names=FALSE, recursive=recursive)
    df <- data.frame(file_names, rep(0, length(file_names)))
    output.file <- file(paste0(path_prefix, "/","image_labels.csv"), "wb")
    write.table(df,
                row.names = FALSE,
                col.names = FALSE,
                file = output.file,
                quote = FALSE,
                append = TRUE,
                sep = ",")
    close(output.file)
    rm(output.file) 
    print(paste0("Your file is located at ", path_prefix, "/", "image_labels.csv. \n
                 This is the same location where your images are stored."))
  } else {
    # get in file
    if(endsWith(directory, "/")){
      inFile <- (paste0(directory, input_file))
      wd <- directory
    } else {
      inFile <- (paste0(directory, "/", input_file))
      wd <- paste0(directory, "/")
    }
    
    if(usingBuiltIn){
      cnames <- colnames(inFile)
      cnames_bool <- "filename" %in% cnames
      if(!cnames_bool){
        stop("Your inFile does not contain a column called 'filename'")
      } 
      df <- data.frame(inFile$filename, rep(0, nrow(inFile)))
      
      # write output
      output.file <- file(paste0(path_prefix, "/", file_prefix, "image_labels.csv"), "wb")
      write.table(df,
                  row.names = FALSE,
                  col.names = FALSE,
                  file = output.file,
                  quote = FALSE,
                  append = TRUE,
                  sep = ",")
      close(output.file)
      rm(output.file) 
      print(paste0("Your file is located at ", path_prefix, "/", file_prefix, "image_labels.csv."))
      
    }else{
      cnames <- colnames(inFile)
      if(images_classified){
        cnames_shouldBe <- c("class", "filename")
      } else{
        cnames_shouldBe <- c("filename")
      }
      
      cnames_bool <- cnames_shouldBe %in% cnames
      if(any(cnames_bool==FALSE)){
        stop("The column names in your input_file must include 'class' and 'filename'. \n
           The 'class' column contains the names of the species in each image. ")
      }
      
      if(images_classified){
        # create a lookup table
        group_name <- unique(inFile$class) 
        class_ID <- seq_along(group_name)
        tblLu <- data.frame(class_ID, group_name)
        
        # make a df that contains the ID for each file
        df1 <- merge(inFile, tblLu, by.x="class", by.y="group_name")
        df2 <- data.frame(df1$filename, df1$class_ID)
      } else{
        df2 <- data.frame(inFile$filename, rep(0, nrow(inFile)))
      }
      
      # write out data frame
      if(trainTest==FALSE){ 
        output.file <- file(paste0(file_prefix, "image_labels.csv"), "wb")
        write.table(df2,
                    row.names = FALSE,
                    col.names = FALSE,
                    file = output.file,
                    quote = FALSE,
                    append = TRUE,
                    sep = ",")
        close(output.file)
        rm(output.file) 
        print(paste0("Your file is located at ", wd, file_prefix, "image_labels.csv."))
      } else {
        # set up training and testng datasets
        ntrain <- floor(nrow(df2)*proptrain)
        ntest <- nrow(df2) - ntrain
        train_rows <- sample(nrow(df2), ntrain, replace=FALSE)
        df.train <- df2[train_rows,]
        df.test <- df2[-train_rows,]
        # write it out
        output.file <- file(paste0(file_prefix, "_train.csv"), "wb")
        write.table(df.train,
                    row.names = FALSE,
                    col.names = FALSE,
                    file = output.file,
                    quote = FALSE,
                    append = TRUE,
                    sep = ",")
        close(output.file)
        rm(output.file) 
        
        output.file <- file(paste0(file_prefix, "_test.csv"), "wb")
        write.table(df.train,
                    row.names = FALSE,
                    col.names = FALSE,
                    file = output.file,
                    quote = FALSE,
                    append = TRUE,
                    sep = ",")
        close(output.file)
        rm(output.file) 
        
        # print information
        print(paste0("Your files are located in ", wd, "\n
                   With the file names: ", file_prefix, "_test.csv and \n", 
                     file_prefix, "train.csv."))
      }
      
    }
    
    if(images_classified){
      # return the lookup table
      return(tblLU)
    }
    
  } # end else for not using find_file_names
}