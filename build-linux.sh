#!/bin/bash

set -e

echo "Building for Linux..."

# Ensure SDL3 is built
if [ ! -d "third-party/sdl3-linux" ]; then
    echo "SDL3 not found. Running setup script..."
    ./setup-sdl3-cross.sh
fi

# Build
mkdir -p build-linux
cd build-linux

cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -G Ninja

ninja

echo "Linux build complete!"
echo "Executable: build-linux/SDL3Game"