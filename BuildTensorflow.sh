#!/bin/bash

# Script, version 2, to build Tensorflow for the Jetson modules


set -e

# There are 4 main parts to this script to build Tensorflow for the Jetson
# line of products.
# Step 1: Prepare the environment
#         This step requires the sudo access, in this step we are going to
#         install all of the package dependencies.  The Jetson also requires
#         8G of swap space if you want to use all of the cores in the build.
# Step 2: Build Bazel to be used for install
# Step 3: Gather all information for the TF environment
# Step 4: Build Tensorflow

# Set some default variables before calling to the command line
BRANCH=v1.11.0
SWAPSIZE=8
# Log the location this was run from
whereami=$(pwd)
PYTHON=python2
install_dir=$whereami

# Define a function to print out the help information
function usage
{
    echo "This bash script will produce a Tensorflow Wheel compatible with    "
	echo "the Jetson system it is run on.                                     "
	echo "                                                                    "
	echo "The assumption is made that you flashed your system with the latest "
	echo "version of Jetpack that included all of CUDA, cuDNN, and TensorRT   "
	echo "if this is not the case then the script will likely fail and you    "
	echo "will need to modify helperscript accordingly                        "
	echo "                                                                    "
	echo "Written by: Jason Tichy                                             "
	echo "Version 1.0: Jan 3rd, 2018                                          "
	echo "Version 1.1: Mar 30th, 2018                                         "
	echo "Version 2.0: Aug 21st, 2018                                         "
	echo "                                                                    "
	echo "usage: ./BuildTensorflow.sh [[-p python]] [[-b branch ][-s swapsize][-d dir] | [-h]]"
    echo "-b | --branch <branchname>   Github branch to clone, i.e r1.4 (default: master)"
    echo "-s | --swapsize <size>  Size of swap file to create to assist building process in GB, i.e. 8"
    echo "-d | --dir <directory> Directory to download files and use for build process, default: pwd/TensorFlow_install"
    echo "-h | --help  This message"
	echo "                         "
	echo "ex: ./BuildTensorflow.sh -p python2 -b v1.11.0"
}


# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -b | --branch )         shift
                                BRANCH=$1
                                ;;
        -s | --swapsize )       shift
                                SWAPSIZE=$1
                                ;;
		-p | --python )         shift
		                        PYTHON=$1
								;;
        -d | --dir )            shift
                                install_dir=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done


# Do the sudo required stuff up front so the user doesn't have to wait
# and monitor the build the whole time
sudo bash ./bazel_dependencies.sh
sudo bash ./tf_dependencies.sh $install_dir $SWAPSIZE

# Test for the existence of bazel and if not build it
# this is in case you have a failed TF build and you don't
# want to keep rebuilding bazel every time you run this script
if [ ! -e bazel ]; then
   bash ./bazel_build.sh
fi

bash ./tf_build.sh $BRANCH $PYTHON
