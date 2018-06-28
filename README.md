# MLWIC: Machine Learning for Wildlife Image Classification in R

<b> package is currently under maintentence. It should be repaired in the next hour: starting 28 June 2018: 10:30 am MT </b>

This package identifies animal species in game camera images by implementing the Species Level model described in [Tabak et al.](https://www.biorxiv.org/content/early/2018/06/13/346809)

*Note: At this point, `MLWIC` is not configured to run on Windows. You can attempt to use Windows, but Step 2 will require more work on your part. We hope to eventually optimize `MLWIC` for windows as well (see note below). If you do not already have it, you will need to install Anaconda <b>using the Python 2.7 version</b> found [here](https://www.anaconda.com/download/#macos). 


<b>Step 1: In R, install the `MLWIC` package</b>
```
devtools::install_github("mikeyEcology/MLWIC")
# then load the MLWIC library
library(MLWIC)
```

<i> You only need to run steps 2-4 the first time you use this package on a computer.</i>\
<b>Step 2: Install TensorFlow on your computer.</b> The function `tensorflow` will do this on Macintosh and Ubuntu machines, but the installation of this software is inconsistent. If you have trouble using our function, you can try doing this independently by following the directions [here](https://www.tensorflow.org/install/). 


<b>Step 3: Download the L1 folder from this [link](https://drive.google.com/file/d/1_VH78A9AgCErMIcsbOlNEBXgASx2pRsP/view?usp=sharing).</b> After clinking on the link, a new tab will open showing L1.zip. Download this folder by clicking on the download button in the upper right hand corner (looks like an arrow pointing down to a line). Unzip the folder and then store this L1 folder in a location that makes sense on your computer (e.g., Desktop). Note the location, as you will specify this as `model_dir` when you run the functions `classify`, `make_output`, and `train`. 


<b>Step 4: Setup your environment for using `MLWIC`</b>\
Run the function `setup`. `python_loc` is the location of Python 2.7 on your computer. On Macs, it is often in the default-you can determine the location by opening a terminal window and typing `which python2.7`. This function installs several necessary Python packages. Running this function will take some time. \
<i> You only need to run steps 2-4 the first time you use this package on a computer.</i>


<i><b>Before running models on your own data, I recommend you try running using the [example  provided](https://github.com/mikeyEcology/MLWIC_examples/tree/master). </b></i>


<b>Classify your images using `classify`.</b> Run the Species Level model (from Tabak et al.) on your images. If you have images with associated labels (you have already classified the animals in the images), you can check the model's function on your images. \
<b>A)</b> Place all of your images in one folder, each image must have a unique name. The absolute location of this folder will be your `path_prefix`. If you don't know how to get your path, you can find some information in [this video](https://www.youtube.com/watch?v=kIhGavBqXYc) or [this blog](https://www.cnet.com/how-to/how-to-copy-a-file-path-in-os-x/). \
<b>B)</b> Create a csv file with only 2 columns. The first column must contain a unique filename for each image in your image directory. The second column must contain a number relating to the species that are in the image. This is the "Class ID" from the [speciesID file in this repository](https://github.com/mikeyEcology/MLWIC/blob/master/speciesID.csv). If you do not know the species in your images, you can put a 0 in each row of this column. Do not name these columns (no column headers) and do not include any more than 2 columns in this file. You will use the name of this file in the `data_info` command. <b>The csv you make must have Unix linebreaks.</b> \
<b>C)</b> For `model_dir`, specify the absolute path to where you stored the L1 folder in step 1. E.g., "C:/Users/Mikey/Desktop" (this would mean that I have placed the L1 folder on my desktop). \
<b>D)</b> For `log_dir`, use the default if you are using our model from [Tabak et al.](https://www.biorxiv.org/content/early/2018/06/13/346809) If you trained your own model using `train`, use the `log_dir_train` that you specified in that function. \
<b>E)</b> `num_classes` is the number of species or groups of species in the model. If you are using our model, `num_classes=28`. If you trained your own model, this is the number that you specified. \
If you are classifying many images at once, you may want to break them into batches of ~10,000, depending on your computer. If you have a computer with a lot of RAM (> 16 GB) or you are using a computing cluster, you will not need to worry about this. 


<b>Make a pretty output csv.</b> After evaluating your model, your output will be in your L1 directory in a format that is not reader friendly. You can use `make_output` to make this output more readable and in a desired location.\
<b>A)</b> `output_location` is the absolute path to where you want to store the output, and `output_name` is the name of a file (ending in `.csv`) where you want to store the output. \
<b>B)</b> `saved_predictions` is the name of the csv where you stored the predictions from `classify`. If you used the default there, use the default here. \
<b>C)</b> `model_dir` is the same location you used in Step 4. 


<b>Train a model.</b> If you have many images with associated labels and you want to train your own model, you can do this using `train`. Steps A, B, and C will be similar to classification, but for Step B, you will want to be sure that column 2 contains meaningful species labels (i.e., don't put a 0 in every row if you want to train the model for multiple species). Your first species must be 0, and subsequent species will be increasing numbers: 0,1,2, don't leave a number unused (e.g., if you have a species with the ID=4, you must have species with IDs=0,1,2,3). <b>The csv you make must have Unix linebreaks.</b>\
<b>D)</b> `log_dir_train` will be the name of the folder that you want to store the trained model information. You will not need to look at this folder, but you will specify it as the `log_dir` when you run `classify`. If you are running multiple models on your machine you will want to use different names each time or else they will be over-written. \
<b>E)</b> `num_classes` is the number of species or groups of species in your dataset. If you have all of your IDs stored in a vector called `IDs`, `num_classes` should be equal to `length(unique(IDs))`. \
<b>F)</b> Note that training a model will require a long time to process. More images and more species or groups will require more time to train. We recommend using a computing cluster. If one is not available, we recommend using a machine that you can afford to leave alone for a considerable amount of time. 


<b>Notes:</b>\
Why doesn't `MLWIC` run on Windows? `MLWIC` uses [TensorFlow](https://www.tensorflow.org/), which on Windows can only be used with Python >= 3.5. Our models depend on Python 2.7. If you can effectively run TensorFlow on Windows with Python 2.7, then you may be able to run `MLWIC` on Windows. 

If you are using this package for a publication, please cite our manuscript: [Machine learning to classify animal species in camera trap images: applications in ecology](https://www.biorxiv.org/content/early/2018/06/13/346809).


