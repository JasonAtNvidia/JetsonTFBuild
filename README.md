# Build TensorFlow Bash Script

This script is intended to assist in installing TensorFlow by source onto a Jetson TX# device

### Pre-built Wheels:

I highly recommend just using the pre-built wheel files.  I build against Compute Capability  5.3 for TX1s, and 6.2 for TX2s.  The result is a larger filesize compared to building against a single architecture, but the wheels are portable between TX1 and TX2.

[TF 1.8.0 w TRT Python 2.7](https://nvidia.box.com/v/TF180-Py27-wTRT)

[TF 1.8.0 w TRT Python 3.5](https://nvidia.box.com/v/TF180-Py35-wTRT)

[TF 1.7.0 w TRT Python 2](https://nvidia.box.com/v/TF170-py27-wTRT)

[TF 1.7.0 w TRT Python 3](https://nvidia.box.com/v/TF170-py35-wTRT)



### How To:

From a terminal window navigate into the folder containing BuildTensorflow.sh

```sh
$ sudo ./BuildTensorflow.sh
```

The build process should take between 4 and 6 hours depending on the performance of your device.

Note:  Due to TensorFlow bug I am turning TF_NEED_TENSORRT=0 by default.  If you are going to build against master you can open helperscript and set this value to 1.
Note:  To build for Python 3, open helperscript and locate ```PYTHON_BIN_PATH=$(which python)``` and change this line to be ```PYTHON_BIN_PATH=$(which python3)```

### Installation

The ```BuildTensorflow.sh``` script will automatically install the Python wheel through pip install as well as place the C++ api objects into /usr/local/include and /usr/local/lib for you.  However, if you wish to save the wheel file, it is located in ```/home/nvidia/TensorFlow_Install/tensorflow_pkg```.


### Todos
* Clean up folder permissions
* Somehow find a way to clean up swap if the build fails or is interrupted
* Include a command line option to build for Python 3

License
----
I do not warranty the use this software.  
By using this script to build and install TensorFlow you are agreeing to the TensorFlow license, located 
[here](https://github.com/tensorflow/tensorflow/blob/master/LICENSE).  
The OpenJDK license is located [here](http://openjdk.java.net/legal/binary-license-2007-08-02.html).  
Bazel uses Apache License 2.0 and is located [here](https://github.com/bazelbuild/bazel/blob/master/LICENSE).