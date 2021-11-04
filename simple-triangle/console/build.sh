#!/bin/bash

# Include our shared scripts
. ../shared-scripts.sh

echo "Checking for build folder ..."
if [ ! -d "build" ]; then
  mkdir build
fi

pushd build > /dev/null
  # Request that CMake configures itself to based on what it finds in the parent folder
  echo "Configuring CMake with Ninja ..."
  cmake -G Ninja ..

  # Start the build process
  echo "Building the project with Ninja ..."
  ninja
popd > /dev/null