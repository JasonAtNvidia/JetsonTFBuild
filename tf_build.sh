#!/bin/bash


# We passed in what branch to download and what version of python to build
BRANCH=$1
PYTHON=$2

# look for the tensorflow folder, if it doesn't exist go ahead and clone it
# (once again, this script usually gets run many times while I'm testing
#  each build of tensorflow before getting it just right)
if [ ! -e tensorflow ]; then
   git clone --single-branch -b $BRANCH https://github.com/tensorflow/tensorflow
fi

# Prepare the environment, helperscript automagically looks through the device
# and finds the libraries and CUDA information to pass to TF
source ./helperscript

# make sure tensorflow knows bazel exists
export PATH="$PATH:$(`pwd`)"

# configure the build of tensorflow
bash ./tensorflow/configure

# Move into Tensorflow and build it.... YAY
cd tensorflow
git apply ../jetson.patch
../bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package ../


