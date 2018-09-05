#!/bin/bash

# Go out and get bazel
wget --no-check-certificate https://github.com/bazelbuild/bazel/releases/download/0.15.2/bazel-0.15.2-dist.zip

# unzip the bazel
unzip bazel-0.15.2-dist.zip -d bazel_build

cd bazel_build
./compile.sh

mv output/bazel ../bazel

cd ..
rm -rf bazel_build
rm -rf bazel-0.15.2-dist.zip
