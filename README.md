# Build TensorFlow Bash Script

This script is intended to assist in installing TensorFlow by source onto a Jetson TX# device

By using this script you are agreeing to the Oracle Java licence agreement.

### How To:

From a terminal window navigate into the folder containing BuildTensorflow.sh

```sh
$ sudo ./BuildTensorflow.sh
```

The build process should take between 4 and 6 hours depending on the performance of your device.


### Installation

The ```BuildTensorflow.sh``` script will automatically install the Python wheel through pip install as well as place the C++ api objects into /usr/local/include and /usr/local/lib for you.  However, if you wish to save the wheel file, it is located in ```/home/nvidia/TensorFlow_Install/tensorflow_pkg```.


### Todos

License
----
Oracle
MIT
