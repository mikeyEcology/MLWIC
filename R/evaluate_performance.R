#' Evaluate performance of a model in \code{MLWIC2} on your dataset
#'
#' \code{evaluate_performance} calculates some basic summary statistics of model 
#' performance using \code{classify}. After running \code{classify}, you will need
#' to run \code{make_output} and have this output as your data frame to put into
#' this function.
#' 
#' @param model_output The output of running \code{classify} after you have run 
#'  \code{make_output} on this output. 
#' @param top5 Boolean variable for if you want to evaluate top-5 results for the model.
#'  This will only work if you saved at least 5 guesses from the model in \code{classify} by 
#'  specifying `top_n=5` or greater. 
#' @param label_tbl A table with words to identify the classes in your dataset. If you are 
#'  using the built in model, this is the speciesID data file that was downloaded with the package.
#'  If you are writing your own `label_tbl`, you need to have columns called "class_ID" and "group_name".
#'  For example, see head(speciesID)
#' @export
evaluate_performance <- 
  function(
    model_output,
    top5 = TRUE,
    label_tbl = speciesID
  ){
    
    # make sure the column names are correct
    cnames <- colnames(model_output)
    cnames_shouldBe <- c("answer", "guess1")
    cnames_bool <- cnames_shouldBe %in% cnames
    if(any(cnames_bool==FALSE)){
      stop("The column names in your model_output file suggest that you have not run \n
           the make_output function. Please run that function first before running this one.")
    }
    
    # make sure there are 5 guesses if top5 was specified
    if(top5){
      if(!("guess5" %in% cnames)){
        stop("You specified top5=TRUE but you do not have 5 classses in your dataset. \n
             Specify top5=FALSE")
      }
    }
    
    # make sure label file is set up properly
    if(!is.null(label_tbl)){
      cnames_shouldBe <- c("class_ID", "group_name")
      cnames_bool <- cnames_shouldBe %in% colnames(label_tbl)
      if(any(cnames_bool==FALSE)){
        stop("Your label_tbl needs to contain columns with the names 'class_ID' and 'group_name'. \n
             Either correct your label_tbl or set label_tbl=NULL. ")
      }
    }
    
    # rename for convenience
    s1 <- model_output
    lab <- data.frame(label_tbl$class_ID)
    lab$group_name <- as.character(label_tbl$group_name)
    
    # total values
    ATP <- sum(s1$answer==s1$guess1)
    ATPp <- ATP/nrow(s1)
    AFN <- sum(s1$answer!=s1$guess1)
    AFNp <- AFN/nrow(s1)
    An <- nrow(s1)
    Arecall <- ATP/(ATP+AFN)
    
    if(top5){
      AT5 <- sum(s1$answer == s1$guess1 | 
                   s1$answer == s1$guess2 | 
                   s1$answer == s1$guess3|
                   s1$answer == s1$guess4|
                   s1$answer == s1$guess5)
      AT5p <- AT5/An
    }
    
    # by species
    species <- unique(s1$answer)
    tbl_study <- matrix(NA, nrow=length(species), ncol=9)
    for(i in seq_along(species)){ # can I vectorize this?
      spD <- s1[s1$answer==species[i], ]
      TP <- sum(spD$answer == spD$guess1)
      TPp <- TP/nrow(spD)
      FN <- sum(spD$answer != spD$guess1)
      FNp <- FN/nrow(spD)
      FP <- sum(s1$answer!= species[i] & s1$guess1 == species[i])
      if(top5){
        T5 <- sum(spD$answer == spD$guess1 | 
                    spD$answer == spD$guess2 | 
                    spD$answer == spD$guess3|
                    spD$answer == spD$guess4|
                    spD$answer == spD$guess5)
        T5p <- T5/nrow(spD)
      }
      
      recall <- TP/(TP+FN)
      precision <- TP/(TP+FP)
      tbl_study[i, 1] <- species[i] 
      tbl_study[i,2] <- nrow(spD) # number of images of this species
      tbl_study[i,3] <- TP
      tbl_study[i,4] <- TPp
      tbl_study[i,5] <- FN
      tbl_study[i,6] <- FP
      tbl_study[i, 7] <- recall
      tbl_study[i, 8] <- precision
      if(top5){
        tbl_study[i,9] <- T5p
      }
    }
    
    colnames(tbl_study) <- c("class_ID", "n_images", "true_positives",
                             "prop_true_positive", "false_negatives", "false_positives",
                             "recall", "precision", "top5_prop")
    
    tbl_study <- as.data.frame(tbl_study)
    tbl_study2 <- tbl_study[order(tbl_study$class_ID),]
    
    if(is.null(label_tbl)){
      return(tbl_study2)
    }else{
      # merge with speciesID names
      tbl_study3 <- merge(tbl_study2, lab, by.x=c("class_ID"), by.y="class_ID")
      tbl_study4 <- helper <- tbl_study3[,c(1,10,2:9)]
      
      # add a row with totals
      adder <- nrow(tbl_study4) +1
      tbl_study4[adder, ] <- c("", "Totals", An, ATP, ATPp, AFN, sum(helper$false_positives),
                               Arecall, ATP/(ATP+sum(helper$false_positives)), AT5p)
      
      return(tbl_study4)
    }
    
    
  }
