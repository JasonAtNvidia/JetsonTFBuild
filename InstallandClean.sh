#!/bin/bash

# Do the actions that require sudo up front because
# installing the python wheel can take a long time
if [ -e "swapfile.swap" ]; then
    echo " There is a swapfile to be removed"
	sudo swapoff swapfile.swap
	sudo rm swapfile.swap
else
    echo " I found no swapfile to clean up"
fi

# Locate any tensorflow wheels produced
pattern_py2="tensorflow-*-cp27*.whl"
py2_files=$( find . -name $pattern_py2 )

pattern_py3="tensorflow-*-cp3*.whl"
py3_files=$( find . -name $pattern_py3 )


# install the tensorflow wheels that were produced
if [ ! -z $py2_files ]; then
    echo " I will install ${py2_files[0]}"
	pip install ${py2_files[0]}
else
    echo " There is no Python 2 file to be installed"
fi

if [ ! -z $py3_files ]; then
    echo " I will install ${py3_files[0]}"
	pip3 install ${py3_files[0]}
else
    echo " There are no Python 3 files to be installed"
fi

echo " I am leaving the bazel binary and the tensorflow directory"
echo " You may want to move bazel to /usr/local/bin if you want it installed"
echo " you may also want to use the tensorflow directory and all of its built glory"
echo " (for instance, installing the TF C++ libraries)"

