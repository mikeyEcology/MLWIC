#' Install TensorFlow for use with \code{MLWIC}
#'
#' \code{MLWIC} requires an installation of tensorflow that can be used by Python.
#' You need to use this before using \code{classify} or \code{train}.
#' @param os The operating system on your computer. Options are "Mac" or "Ubuntu".
#'  Specifying "Windows" will thrown an error because we cannot automatically install
#'  TensorFlow on Windows at this time.

tensorflow <- function(os="Mac"){

  ## Check for python 2.7
  vpython <- system("pyv=\"$(python -V 2>&1)\" | echo $pyv | grep \"2.7\"") ## come back to this

  if(vpython == TRUE){
    print("Python is installed. Installing homebrew, protobuf, pip, and tensorflow.")

    if(os == "Mac"){

      system("/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"")
      system("brew install protobuf")
      system("sudo easy_install --upgrade pip")
      system("sudo easy_install --upgrade six")

      system("sudo pip install tensorflow")
      ## Something to validate installation, beyond this.
      system("python import_tf.py")

    }else if(os == "Ubuntu"){
      system("sudo apt-get install python-pip python-dev")   # for Python 2.7
      system("pip install tensorflow")

      system("python import_tf.py")

    }else if(os == "Windows"){
      print("Sorry. MLWIC does not run on Windows yet.")

    }else{
      print('Specify operating system - \"Mac\", \"Windows\", or \"Ubuntu\"')
    }

  }else{
    print("Python needs to be installed. Install Python 2.7, ideally Anaconda, before proceeding. MLWIC does not work with Python 3 at this time.")
  }

}
