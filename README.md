# MLWIC

*Note: At this point, MLWIC will only run on MacIntosh computers. You can attempt to use Windows, but Step 3 will require more work on your part. We hope to eventually optimize MLWIC for windows as well. 

Step 1: Download the L1 folder from this github directory. Store this folder in a location that makes sense on your computer. Note the location, as you will specify this as `model_dir` when you run the functions `MLWIC_eval`, `MLWIC_make_output`, and `MLWIC_train`.

Step 2: In the R console, install the `MLWIC` package using the command
```
devtools::install_github("MLWIC")
# then load the MLWIC library
library(MLWIC)
```

Step 3: Setup your environment for using MLWIC
```
MLWIC_setup()
```
`python_loc` is the location of Python 2.7 on your computer. On Macs, it is often in the default directory. This function installs necessary software including TensorFlow and several necessary Python packages. Running this function will take some time.

Step 4: Evaluate the model on your images using `MLWIC_eval`. If you have images with associated labels (you have already classified the animals in the images), you can check the model's function on your images. \
A) Place all of your images in one folder, each image must have a unique name. The absolute location of this folder will be your `path_prefix`. \
B) Create a csv file with only 2 columns. The first column must contain a unique filename for each image in your image directory. The second column must contain a number relating to the species that are in the image. This is the "Class ID" from Table 1 in Tabak et al. If you do not know the species in your images, you can put a 0 in each row of this column. Do not name these columns (no column headers) and do not include any more than 2 columns in this file. You will use the name of this file in the `data_info` command. \
C) For `model_dir`, specify the absolute path to where you stored the L1 folder in step 1. E.g., "C:/Users/Mikey/Desktop" (this would mean that I have placed the L1 folder on my desktop). Do not include a `/` at the end of this string.\
D) For `log_dir`, use the default if you are using our model from Tabak et al. If you trained your own model using `MLWIC_train`, use the `log_dir_train` that you specified in that function. \
E) `num_classes` is the number of species or groups of species in the model. If you are using our model, `num_classes=28`. If you trained your own model, this is the number that you specified. \


Step 5: Making a pretty output csv. After evaluating your model, your output will be in your L1 directory in a format that is not reader friendly. You can use `MLWIC_make_output` to make this output more readable and in a desired location.\
A) `output_location` is the absolute path to where you want to store the output, and `output_name` is the name of a file (ending in `.csv`) where you want to store the output. \
B) `saved_predictions` is the name of the csv where you stored the predictions from `MLWIC_eval`. If you used the default there, use the default here. 
C) `model_dir` is the same location you used in Step 4. 

Step 6: Training a model. If you have many images with associated labels and you want to train your own model, you can do this using `MLWIC_train`. Steps A, B, and C will be similar to Step 4, but for Step B, you will want to be sure that column 2 contains meaningful species labels (i.e., don't put a 0 in every row if you want to train the model for multiple species). Your first species must be 0, and subsequent species will be increasing numbers: 0,1,2, don't leave a number unused (e.g., if you have a species with the ID=4, you must have species with IDs=0,1,2,3). \
D) `log_dir_train` will be the name of the folder that you want to store the trained model information. You will not need to look at this folder, but you will specify it as the `log_dir` when you run `MLWIC_eval`. If you are running multiple models on your machine you will want to use different names each time or else they will be over-written. 
E) `num_classes` is the number of species or groups of species in your dataset. If you have all of your IDs stored in a vector called `IDs`, `num_classes` should be equal to `length(unique(IDs))`. 
F) Note that training a model will require a long time to process. More images and more species or groups will require more time to train. We recommend using a computing cluster. If one is not available, we recommend using a machine that you can afford to leave alone for a considerable amount of time. 
