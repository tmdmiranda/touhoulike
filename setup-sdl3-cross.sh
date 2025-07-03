#!/bin/bash

set -e

echo "Setting up SDL3 for cross-compilation..."

# Create directories
 mkdir -p third-party
 cd third-party

 # Clone SDL3 if not already cloned
 if [ ! -d "SDL" ]; then
     git clone https://github.com/libsdl-org/SDL.git
     fi

     cd SDL

#     # Build SDL3 for Linux (host system)
     echo "Building SDL3 for Linux..."
     mkdir -p build-linux
     cd build-linux

     cmake .. \
         -DCMAKE_BUILD_TYPE=Release \
             -DCMAKE_INSTALL_PREFIX=../../sdl3-linux \
                 -DSDL_SHARED=ON \
                     -DSDL_STATIC=OFF

                     make -j$(nproc)
                     make install

                     cd ..

                     # Build SDL3 for Windows (cross-compile)
                     echo "Building SDL3 for Windows..."
                     mkdir -p build-windows
                     cd build-windows

                     cmake .. \
                         -DCMAKE_TOOLCHAIN_FILE=../../../cmake/windows-toolchain.cmake \
                             -DCMAKE_BUILD_TYPE=Release \
                                 -DCMAKE_INSTALL_PREFIX=../../sdl3-windows \
                                     -DSDL_SHARED=ON \
                                         -DSDL_STATIC=OFF

                                         make -j$(nproc)
                                         make install

                                         cd ../../..

                                         echo "SDL3 setup complete!"
                                         echo "Linux libraries: third-party/sdl3-linux"
                                         echo "Windows libraries: third-party/sdl3-windows"

