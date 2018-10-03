# Build TensorFlow Bash Script

This script is intended to assist in installing TensorFlow by source onto a Jetson TX# device
This script also works great on a Jetson AGX Xavier Device as well.

### Pre-built Wheels:

I highly recommend just using the pre-built wheel files.  I build against Compute Capability  5.3 for TX1s, and 6.2 for TX2s.  The result is a larger filesize compared to building against a single architecture, but the wheels are portable between TX1 and TX2.

[TF 1.11.0 w TRT Python 2.7](https://nvidia.box.com/v/JP33-TF1-11-0-py27-wTRT)

[TF 1.11.0 w TRT Python 3.5](https://nvidia.box.com/v/JP33-TF1-11-0-py35-wTRT)

[TF 1.10.1 w TRT Python 2.7](https://nvidia.box.com/v/TF1101-Py27-wTRT)

[TF 1.10.1 w TRT Python 3.5](https://nvidia.box.com/v/TF1101-Py35-wTRT)



### How To:

Script is updated from the original to contain sudo commands to the front and clean up folder permissions.  No longer will it install TF for you, but install it will use sudo permissions to install all of the packages up front and then leave you with bazel and the tensorflow wheel locally for you to do what you would like with them.

From a terminal window navigate into the folder containing BuildTensorflow.sh

```sh
$ ./BuildTensorflow.sh
```

The build process should take between 4 and 6 hours depending on the performance of your device.


### Installation

I highly encourage you to look into the shell scripts to see how everything is done.  I try to keep these scripts up to date but sometimes I cannot fix an issue right away and you might be able to resolve the conflict yourself.

BuildTensorflow.sh has some options, not all of them might be operational at the moment.

-p --python "python"  this will tell the system where to go look for python libraries.  This will get passed directly to the "which" command, therefor use python like it would be called from bash
-b --branch "TF branch" this will checkout the tag or branch version from the Tensorflow base code
-s --swapsize "<int>" this will tell the Jetson how much swap memory to create to build TF, I default to 8 which will create 8 gigs of swap.

Examples:

```sh
$ ./BuildTensorflow.sh
```

```sh
$ ./BuildTensorflow.sh -p python3
```

```sh
$ ./BuildTensorflow.sh -b v1.10.1 -p python3
```

When you are finished building there will be bazel and the tensorflow wheel left in the directory you just built in.  You can install the wheels yourself using pip or pip3, or I have included a handy bash script to clean up the environment for you.

```sh
$ ./InstallandClean.sh
```

This just removes the swap and installs any TensorFlow wheels located in the local directory.


License
----
Licensed under the general MIT opensource license.
I do not warranty the use this software.  
By using this script to build and install TensorFlow you are agreeing to the TensorFlow license, located 
[here](https://github.com/tensorflow/tensorflow/blob/master/LICENSE).  
The OpenJDK license is located [here](http://openjdk.java.net/legal/binary-license-2007-08-02.html).  
Bazel uses Apache License 2.0 and is located [here](https://github.com/bazelbuild/bazel/blob/master/LICENSE).