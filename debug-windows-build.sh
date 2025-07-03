#!/bin/bash

echo "=== Debugging Windows Build ==="

# Check if the executable exists
if [ ! -f "build-windows/SDL3Game.exe" ]; then
    echo "ERROR: Windows executable not found!"
    exit 1
fi

# Check the architecture of the built executable
echo "Checking executable architecture:"
file build-windows/SDL3Game.exe

# Check what DLLs it depends on
echo -e "\nChecking DLL dependencies:"
x86_64-w64-mingw32-objdump -p build-windows/SDL3Game.exe | grep "DLL Name"

# Check SDL3 DLL architecture
echo -e "\nChecking SDL3 DLL architecture:"
if [ -f "third-party/sdl3-windows/bin/SDL3.dll" ]; then
    file third-party/sdl3-windows/bin/SDL3.dll
else
    echo "SDL3.dll not found!"
fi

echo -e "\nBuild completed. Check output above for issues."