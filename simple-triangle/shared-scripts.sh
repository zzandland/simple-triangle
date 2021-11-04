#!/bin/bash

# Given the name of a Homebrew formuala, check if it's installed and if not, install it.
fetch_brew_dependencies() {
  FORMULA_NAME=$1

  echo "Fetching brew dependency: '$FORMULA_NAME'."

  if brew ls --versions $FORMULA_NAME > /dev/null; then
    echo "Dependency '$FORMULA_NAME' is already installed, continuing ..."
  else
    echo "Dependency '$FORMULA_NAME' is not installed, installing via Homebrew ..."
    brew install $FORMULA_NAME
  fi
}

# Download the SDL2 library source into `third-party` directory
fetch_third_party_lib_sdl() {
  pushd ../../ > /dev/null
    # Check if no 'third-party' directory exists
    if [ ! -d "third-party" ]; then
      mkdir third-party
    fi
  popd > /dev/null

  # Navigate to the `third-party` directory
  pushd ../../third-party > /dev/null
    # Check if SDL directory exists
    if [ ! -d "SDL" ]; then
      echo "Fetching SDL (SDL2: 2.0.16) ..."

      # Download the SDL2 source zip file
      wget https://www.libsdl.org/release/SDL2-2.0.16.zip

      # Unzip
      unzip -q SDL2-2.0.16.zip

      # Rename the unzipped directory
      mv SDL2-2.0.16 SDL

      # Remove the zip file
      rm SDL2-2.0.16.zip
    else
      echo "SDL library already exists in 'third-party' directory ..."
    fi
  popd > /dev/null
}

# Download the SDL2 MacOS Framework into `Frameworks` directory
fetch_framework_sdl() {
  # Check if no 'Frameworks' directory exists
  if [ ! -d "Frameworks" ]; then
    mkdir Frameworks
  fi

  # Navigate into the 'Frameworks' directory
  pushd Frameworks > /dev/null
    if [ ! -d "SDL2.framework" ]; then
      # Download the SDL2 MacOS Framework image
      wget https://www.libsdl.org/release/SDL2-2.0.16.dmg

      echo "Mounting DMG file ..."
      hdiutil attach SDL2-2.0.16.dmg

      echo "Copying SDL2.framework from DMG file into the current folder ..."
      cp -R /Volumes/SDL2/SDL2.framework .

      echo "Unmounting DMG file ..."
      hdiutil detach /Volumes/SDL2

      echo "Deleting DMG file ..."
      rm SDL2-2.0.16.dmg

      # Navigate into the SDL2 directory
      pushd SDL2.framework > /dev/null
        echo "Code signing SDL2.framework ..."
        codesign -f -s - SDL2
      popd > /dev/null
    else
      echo "SDL2.framework already exists ..."
    fi
  popd > /dev/null
}

fetch_sdl() {
  fetch_third_party_lib_sdl
  fetch_framework_sdl
}
