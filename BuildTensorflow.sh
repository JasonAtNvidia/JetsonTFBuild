#!/bin/bash
# Install Tensorflow (meant for Jetson TX# models)


BRANCH=master
SWAPSIZE=8
# Log the location this was run from
whereami=$(pwd)
install_dir=$whereami/TensorFlow_Install

function usage
{
    echo "usage: sudo ./BuildTensorflow.sh [[-b branch ][-s swapsize][-d dir] | [-h]]"
    echo "-b | --branch <branchname>   Github branch to clone, i.e r1.4 (default: master)"
    echo "-s | --swapsize <size>  Size of swap file to create to assist building process in GB, i.e. 8"
    echo "-d | --dir <directory> Directory to download files and use for build process, default: pwd/TensorFlow_install"
    echo "-h | --help  This message"
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

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root, use sudo "$0" instead" 1>&2
   exit 1
fi

echo "This bash script will install TensorFlow       "
echo "branch on a Jetson system that has been setup  "
echo "by Jetpack with CUDA and cuDNN already installed."
echo "                                               "
echo "If this is not the case then this script will  "
echo "likely fail                                    "
echo "                                               "
echo "Expect this script to take up to 6+ hours      "
echo "                                               "
echo "Writen by: Jason Tichy < jtichy@nvidia.com >   "
echo "Version 1.0: Jan 3rd, 2018                     "
echo "Version 1.1: Mar 30, 2018 Added TensorRT support"
echo "                                               "
echo "Note: TF v 1.7.0 release contains a bug for arm"
echo "because of a hardcoded x86 path in the TensorRT"
echo "Bazel script, you will need to use master to   "
echo "build with TensorRT support                    "
sleep 5s # Sleep for 3 seconds

# Regain CUDA in the PATH of root
export CUDA_HOME=/usr/local/cuda
export PATH=${CUDA_HOME}/bin:${PATH}
export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

# Set simple error failing
set -e

# Set Jetson Performance to Best
{ #try the following command
    nvpmodel -m 0
} || { #catch if failed
    echo "Performance function not available for this device"
}

# Update Repositories
apt-get update

# Create a directory to handle all of the install
cd $HOME
if [ ! -d "$install_dir" ]; then
    mkdir $install_dir
fi
cd $install_dir


# Install useful tools, 
#   htop is nice graphical version of top, 
#   ncdu is graphical disk utilization
#   mlocate contains the locate command
apt-get install htop ncdu mlocate -y
updatedb



##########################################
# Install Bazel                          #
# Check if Bazel was already installed   #
##########################################
{ # try in case you've run this before

bazel version

} || { # catch

## Install Prereqs for Bazel and Tensorflow
apt-get install openjdk-8-jdk -y
apt-get install zip unzip autoconf automake libtool curl zlib1g-dev maven -y
apt-get install python-numpy python-enum34 python-mock swig python-dev python-pip python-wheel -y
apt-get install python3-dev python3-pip python3-wheel python3-numpy -y
# Go out and get Bazel 0.9
wget --no-check-certificate https://github.com/bazelbuild/bazel/releases/download/0.15.0/bazel-0.15.0-dist.zip
# Unzip and install Bazel
unzip bazel-0.15.0-dist.zip -d bazel
chmod -R ug+rwx bazel
cd bazel
./compile.sh
cp output/bazel /usr/local/bin
chown -R $(whoami) /usr/local/bin
# Cleanup and save disk space
cd $install_dir
rm -r -f bazel-0.15.0-dist.zip
rm -r -f bazel
}

#########################################
# Install Tensorflow
#########################################

# Go out and get TensorFlow source code
cd $install_dir
if [ ! -d "tensorflow" ]; then
    git clone https://github.com/tensorflow/tensorflow
fi

cd tensorflow/
git checkout $BRANCH

if [ $BRANCH == "master" ] || [ $BRANCH == "r1.8" ]; then
    git apply $whereami/tx2.patch
fi


# Use the handy script to set Environment Variables
# Otherwise, configure will be an interactive process
source $whereami/helperscript

# Run the configure bash script (that runs configure.py)
source ./configure


# This goes much smoother with a swap space
# Tensorflow will use more than 8 gigs of memory
# while building itself

#Create a swapfile for Ubuntu at the current directory location
if [ ! -f $install_dir/swapfile.swap ] && [ ! -z "$SWAPSIZE" ]; then
    echo "Creating Swap for build process"
    fallocate -l $SWAPSIZE"G" $install_dir/swapfile.swap
    chmod 600 $install_dir/swapfile.swap
    mkswap $install_dir/swapfile.swap
    
fi

{ #try
  swapon $install_dir/swapfile.swap
} || { # catch
  echo "Looks like Swap not desired or is already in use"
}



# Execute bazel to build TensorFlow, this takes a long time
bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
# Use build_pip_package to actually build the pip package
bazel-bin/tensorflow/tools/pip_package/build_pip_package $install_dir/tensorflow_pkg
# Sleep the system to ensure the system can find the wheel file
sleep 5s
chown $(whoami) $install_dir
# Install the Tensorflow into Python
for entry in $install_dir/tensorflow_pkg/*; do
    pip install $entry
done

# Build the TensorFlow C++ API for fun
bazel build --config=opt --config=cuda //tensorflow:libtensorflow_cc.so
mkdir /usr/local/include/tf
cp -r bazel-genfiles/ /usr/local/include/tf/
cp -r tensorflow /usr/local/include/tf/
cp -r third_party /usr/local/include/tf/
cp -r bazel-bin/tensorflow/libtensorflow_cc.so /usr/local/lib/

#######################################
# Clean up
#######################################

swapoff $install_dir/swapfile.swap
swapoff -a
rm $install_dir/swapfile.swap

# Back to where we came from
cd $whereami
