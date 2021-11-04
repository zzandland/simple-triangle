#!/bin/bash

# Include the shared scripts from the parent folder
. ../shared-scripts.sh

# Ask Homebrew to fetch our required programs
fetch_brew_dependencies "wget"
fetch_brew_dependencies "cmake"
fetch_brew_dependencies "ninja"

fetch_sdl

echo "All dependencies installed. Setup complete."
