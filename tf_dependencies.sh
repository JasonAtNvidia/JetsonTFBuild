#!/bin/bash

# install tensorflow dependencies

install_dir=$1
SWAPSIZE=$2

apt-get install python-numpy python-scipy python-pip python-wheel -y
apt-get install python-enum32 python-mock python-h5py -y
apt-get install python3-dev python3-numpy python3-scipy python3-pip python3-wheel -y
apt-get install python3-mock python3-h5py -y
# mlocate will be used to locate libraries needed by TF
apt-get install mlocate -y
updatedb

# TF 1.10 version requires keras libraries be present for the build
pip install keras_applications==1.0.4 --no-deps
pip install keras_preprocessing==1.0.2 --no-deps

pip3 install keras_applications==1.0.4 --no-deps
pip3 install keras_preprocessing==1.0.2 --no-deps
pip3 install enum34

# Build the deviceQuery script to allow us to pull out device information
cuda_location=/usr/local/cuda
cd $cuda_location/samples/1_Utilities/deviceQuery
make -s

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
