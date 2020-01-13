#' Install TensorFlow for use with \code{MLWIC}
#'
#' \code{MLWIC} requires an installation of tensorflow that can be used by Python.
#'  You need to use this before using \code{classify} or \code{train}. If this is your first time using
#'  this function, you should see additional documentation at https://github.com/mikeyEcology/MLWIC .
#'  This function will install tensorflow on Linux machines; if you are using Windows,
#'  you will need to install tensorflow on your own following the directions here:
#'  https://www.tensorflow.org/install/install_windows. I recommend using the installation with
#'  Anaconda.
#'
#'
#' @param os The operating system on your computer. Options are "Mac" or "Ubuntu".
#'  Specifying "Windows" will thrown an error because we cannot automatically install
#'  TensorFlow on Windows at this time.
#' @export

tensorflow <- function(os="Mac"){

  ## Check for python 2.7
  vpython <- system("pyv=\"$(python -V)\" | echo $pyv| grep \"Python\"") 

  if(vpython == TRUE){
    print("Python is installed. Installing homebrew, protobuf, pip, and tensorflow.")

    if(os == "Mac"){

      system("/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"")
      system("brew install protobuf")
      system("sudo easy_install --upgrade pip")
      system("sudo easy_install --upgrade six")

      system("sudo pip install tensorflow==1.14")
      ## Something to validate installation, beyond this.
      #system("python import_tf.py")

      # I think I need to add: conda install tensorflow

    }else if(os == "Ubuntu"){
      system("sudo apt-get install python-pip python-dev")   # for Python 2.7
      system("pip install tensorflow==1.14")

      #system("python import_tf.py")

    }else if(os == "Windows"){
      print("Sorry. MLWIC cannot install tensorflow on Windows. Please visit
            https://www.tensorflow.org/install/install_windows for tensorflow installation instructions and install a version 
that is less than 2.0 (for example install tensorflow==1.14).")

    }else{
      print('Specify operating system - \"Mac\", \"Windows\", or \"Ubuntu\"')
    }

  }else{
    print("Python needs to be installed.")
  }

}
