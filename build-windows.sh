#!/bin/bash

set -e

echo "Building for Windows..."

# Check if MinGW-w64 is installed
if ! command -v x86_64-w64-mingw32-gcc &> /dev/null; then
    echo "MinGW-w64 not found. Please install it:"
    echo "sudo pacman -S mingw-w64-gcc"
    exit 1
fi

# Ensure SDL3 is built for Windows
if [ ! -d "third-party/sdl3-windows" ]; then
    echo "SDL3 for Windows not found. Running setup script..."
    ./setup-sdl3-cross.sh
fi

# Build
mkdir -p build-windows
cd build-windows

cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=../cmake/windows-toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -G Ninja

ninja

echo "Windows build complete!"
echo "Executable: build-windows/SDL3Game.exe"
echo "Required DLL: third-party/sdl3-windows/bin/SDL3.dll"