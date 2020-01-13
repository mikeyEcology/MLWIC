# MLWIC: Machine Learning for Wildlife Image Classification in R

This package identifies animal species in camera trap images by implementing the model described in [Tabak et al.](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.13120). I am currently developing [MLWIC2](https://github.com/mikeyEcology/MLWIC2), which has some added functionality (including Shiny apps) and a newly-trained model with 58 species, but is still in the development stage. The initialization in steps 2 and 4 will be the same in the new package. 


<b>`MLWIC` will run on Python 3.6 and on Windows computers</b>, but running on Windows will require you to install tensorflow (a version less than 2.0) software on your own. If you are having trouble running `MLWIC` on Windows, you can see [this companion tutorial](https://github.com/mikeyEcology/MLWIC_examples/blob/master/MLWIC_Windows_Set_up.md) that was graciously provided by a Windows `MLWIC` user for some additional help.\
If you do not already have it, you will need to install Anaconda found [here](https://www.anaconda.com/download/#macos). During the Anacoda installation, you will be asked if you want to install Python; you should say yes, and if you install it in the location they suggest on a Mac, it will be the default location that is used by the functions. 

<b>Step 1: In R, install the `MLWIC` package</b>
```
devtools::install_github("mikeyEcology/MLWIC")
# then load the MLWIC library
library(MLWIC)
```

<i> You only need to run steps 2-4 the first time you use this package on a computer.</i>\
<b>Step 2: Install TensorFlow (<2.0) on your computer.</b> The function `tensorflow` will do this on Macintosh and Ubuntu machines, but the installation of this software is inconsistent. If you have trouble using our function or you are using a Windows computer, you can try doing this independently by following the directions [here](https://www.tensorflow.org/install/). 


<b>Step 3: Download the L1 folder from this [link](https://drive.google.com/file/d/1dY-49drRrSotFMHOOPZXrTgl5gqozGVL/view?usp=sharing).</b> After clinking on the link, a new tab will open showing L1.zip. Download this folder by clicking on the download button in the upper right hand corner (looks like an arrow pointing down to a line). Unzip the folder and then store this L1 folder in a location that makes sense on your computer (e.g., Desktop). Note the location, as you will specify this as `model_dir` when you run the functions `classify`, `make_output`, and `train`. 


<b>Step 4: Setup your environment for using `MLWIC`</b>\
Run the function `setup`. `python_loc` is the location of Python on your computer. On Macs, it is often in the default-you can determine the location by opening a terminal window and typing `which python`. This function installs several necessary Python packages. Running this function will take a few minutes. If you already have a conda environment called "r-reticulate" with Python packages installed, you can specify `r_reticulate = TRUE`; if you don't know what this means, leave this argument as the default by not specifying it. You may see some errors when you run `setup` - you can ignore these; if there are problems with the installation, whey will become apparent when you run `classify`.\
<i> You only need to run steps 2-4 the first time you use this package on a computer.</i>


<i><b>Before running models on your own data, I recommend you try running using the [example  provided](https://github.com/mikeyEcology/MLWIC_examples/tree/master). </b></i>

<b>Using absolute paths or avoiding them:</b> MLWIC uses absolute paths because the functions need to find your images, your image labels, the L1 folder, and your Python installation. Some users have trouble with absolute paths, so I updated the functions such that you don't need to specify your path for images and image labels if you follow these instructions. Put all of your images in a folder called "images" and place this folder in a specific folder (your working directory). Put your image labels in a csv called "image_labels.csv" (be sure to follow the instructions below under <b>C</b> when setting up your csv), and put this csv in the same folder (your working directory). Put the L1 folder inside this folder also. Before you run `classify`, `make_output`, or `train` in R, set your working directory to this folder and the function will find the absolute paths to your images and csv. If you prefer to specify absolute paths explicitly (this is an easier way to store your data), you can still specify these paths in the functions. 

<b>Classify your images using `classify`.</b> Run the model (from Tabak et al.) on your images. If you have images with associated labels (you have already classified the animals in the images), you can check the model's function on your images. \
<b>A)</b> If you have not done so already, resize your images to a resolution of 256x256 pixels. (Note that some users have had success in using `classify` and `train` without first resizing images. If it saves you time and frustration to avoid re-sizing, you can consider this option.) There are several options on the web to do this automatically for all of your images, one option uses Python and can be found [here](https://github.com/Evolving-AI-Lab/deep_learning_for_camera_trap_images/blob/master/resize.py). One user suggested the EBImage package in R, and you can find his code [here](https://github.com/mikeyEcology/MLWIC/pull/17/commits), but I have not tested this. Resizing should reduce the amount of time that the functions run and it will make your images more portable (i.e., easier to move to a server). \
<b>B)</b> Place all of your images in one folder, each image must have a unique name. The absolute location of this folder will be your `path_prefix`. If you name this folder "images", and place it in your current working directory, the function will find it and you should not specify anything for path_prefix when you run `classify`. \
<b>C)</b> Create a csv file with only 2 columns. The first column must contain a unique filename for each image in your image directory. The second column must contain a number relating to the species that are in the image. This is the "Class ID" from the [speciesID file in this repository](https://github.com/mikeyEcology/MLWIC/blob/master/speciesID.csv). If you do not know the species in your images, you can put a 0 in each row of this column. Do not name these columns (no column headers) and do not include any more than 2 columns in this file. You will use the name of this file in the `data_info` command. <b>The csv you make must have Unix linebreaks.</b> If you name this csv "image_labels.csv" and put it in your working directory, the function will find it and you should not specify anything for data_info when running `classify`. \
<b>D)</b> For `model_dir`, specify the absolute path to where you stored the L1 folder in step 1. E.g., "C:/Users/Mikey/Desktop" (this would mean that I have placed the L1 folder on my desktop). If you put this L1 folder in your working directory, the function will find it and you do not need to specify model_dir.\
<b>E)</b> For `log_dir`, use the default if you are using our model from [Tabak et al.](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.13120) If you trained your own model using `train`, use the `log_dir_train` that you specified in that function. \
<b>F)</b> `num_classes` is the number of species or groups of species in the model. If you are using our model, `num_classes=28`. If you trained your own model, this is the number that you specified. \
If you are classifying many images at once, you may want to break them into batches of ~10,000, depending on your computer. If you have a computer with a lot of RAM (> 16 GB) or you are using a computing cluster, you will not need to worry about this. \
<b>G)</b> `top_n` is the number of guesses that classes that the model will provide guesses for. E.g., if `top_n=5`, the output will include the top 5 classes that it thinks are in the image (and the confidences that are associated with these guesses). Note that you must have `top_n <= num_classes`. Currently, the `make_output` function will only work if `top_n=5`. \
<b>H)</b> We are starting to collect data on the accuracy of this model on different users' images. Please consider sharing how the model performed on your images following the [instructions here](https://github.com/mikeyEcology/MLWIC/issues/24). \
<b>Note</b> When running `classify`, if you get an error "No Module named 'tensorflow'" and you are using a Windows computer, you may need to upgrade your setuptools. [See a discussion of the problem here](https://github.com/mikeyEcology/MLWIC/issues/4). Another option is to [try installing tensorflow manually](https://www.tensorflow.org/install/). Some Windows users have also found that they need to uninstall and reinstall python, anaconda, and tensorflow. 


<b>Make a pretty output csv.</b> After evaluating your model, your output will be in your L1 directory in a format that is not reader friendly. You can use `make_output` to make this output more readable and in a desired location.\
<b>A)</b> `output_location` is the absolute path to where you want to store the output, and `output_name` is the name of a file (ending in `.csv`) where you want to store the output. \
<b>B)</b> `saved_predictions` is the name of the csv where you stored the predictions from `classify`. If you used the default there, use the default here. \
<b>C)</b> `model_dir` is the same location you used in Step 4. 


<b>Train a model.</b> If you have many images with associated labels and you want to train your own model, you can do this using `train`. Steps A, B, C, and D will be similar to classification, but for Step C, you will want to be sure that column 2 contains meaningful species labels (i.e., don't put a 0 in every row if you want to train the model for multiple species). Your first species must be 0, and subsequent species will be increasing numbers: 0,1,2, don't leave a number unused (e.g., if you have a species with the ID=4, you must have species with IDs=0,1,2,3). <b>The csv you make must have Unix linebreaks.</b>\
<b>E)</b> `log_dir_train` will be the name of the folder that you want to store the trained model information. You will not need to look at this folder, but you will specify it as the `log_dir` when you run `classify`. If you are running multiple models on your machine you will want to use different names each time or else they will be over-written. \
<b>F)</b> `num_classes` is the number of species or groups of species in your dataset. If you have all of your IDs stored in a vector called `IDs`, `num_classes` should be equal to `length(unique(IDs))`. \
<b>G)</b> If your `num_classes` is not equal to the number in the built in model (`num_classes != 28`), you will need to specify `retrain=FALSE`. \
<b>H)</b> Note that training a model will require a long time to process. More images and more species or groups will require more time to train. We recommend using a computing cluster. If one is not available, we recommend using a machine that you can afford to leave alone for a considerable amount of time. 


<b>Notes:</b>\
If you would like to use the 3.7 million images that we used to train our model, they can be found [here](http://lila.science/datasets/nacti). Microsoft is generously hosting this dataset for free as part of their LILA image dataset program.

If you are using this package for a publication, please cite our manuscript: \
Tabak, M. A., M. S. Norouzzadeh, D. W. Wolfson, S. J. Sweeney, K. C. VerCauteren, N. P. Snow, J. M. Halseth, P. A. D. Salvo, J. S. Lewis, M. D. White, B. Teton, J. C. Beasley, P. E. Schlichting, R. K. Boughton, B. Wight, E. S. Newkirk, J. S. Ivan, E. A. Odell, R. K. Brook, P. M. Lukacs, A. K. Moeller, E. G. Mandeville, J. Clune, and R. S. Miller. (2019). [Machine learning to classify animal species in camera trap images: Applications in ecology](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.13120). <i>Methods in Ecology and Evolution</i> 10(4): 585-590.

and this package

Tabak, M. A., M. S. Norouzzadeh, D. W. Wolfson, S. J. Sweeney, K. C. VerCauteren, N. P. Snow, J. M. Halseth, P. A. D. Salvo, J. S. Lewis, M. D. White, B. Teton, J. C. Beasley, P. E. Schlichting, R. K. Boughton, B. Wight, E. S. Newkirk, J. S. Ivan, E. A. Odell, R. K. Brook, P. M. Lukacs, A. K. Moeller, E. G. Mandeville, J. Clune, and R. S. Miller. 2018. mikeyEcology/MLWIC: Machine Learning for Wildlife Image Classification (MLWIC) (Version v0.1). [DOI: 10.5281/zenodo.1445736](http://doi.org/10.5281/zenodo.1445736).

Some users have found low accuracy when running the built in model on their images. It is highly advised that users test the model on some images from their dataset that have been manually classified before assuming that the output of the model will be the correct species. 


