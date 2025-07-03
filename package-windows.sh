#!/bin/bash

set -e

if [ ! -f "build-windows/SDL3Game.exe" ]; then
    echo "Windows build not found. Run ./build-windows.sh first."
    exit 1
fi

echo "Creating enhanced Windows distribution..."

# Create distribution directory
rm -rf dist-windows
mkdir -p dist-windows

# Copy executable
cp build-windows/SDL3Game.exe dist-windows/

# Copy SDL3 DLL
if [ -f "third-party/sdl3-windows/bin/SDL3.dll" ]; then
    cp third-party/sdl3-windows/bin/SDL3.dll dist-windows/
else
    echo "WARNING: SDL3.dll not found!"
fi

# Copy MinGW runtime DLLs (this often fixes 0xc000007b)
MINGW_PATH="/usr/x86_64-w64-mingw32/bin"

# Essential MinGW DLLs
REQUIRED_DLLS=(
    "libgcc_s_seh-1.dll"
    "libstdc++-6.dll"
    "libwinpthread-1.dll"
)

echo "Copying MinGW runtime DLLs..."
for dll in "${REQUIRED_DLLS[@]}"; do
    if [ -f "$MINGW_PATH/$dll" ]; then
        cp "$MINGW_PATH/$dll" dist-windows/
        echo "  ✓ $dll"
    else
        echo "  ✗ $dll (not found - might not be needed)"
    fi
done

# Copy assets if they exist
if [ -d "assets" ]; then
    cp -r assets dist-windows/
fi

# Create a batch file to run the game
cat > dist-windows/run_game.bat << 'EOF'
@echo off
echo Starting SDL3 Game...
SDL3Game.exe
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Game exited with error code: %ERRORLEVEL%
    echo Press any key to close...
    pause >nul
)
EOF

# Create a more detailed README
cat > dist-windows/README.txt << EOF
SDL3 Game - Windows Distribution
==============================

To run the game:
1. Double-click run_game.bat (recommended)
2. Or double-click SDL3Game.exe directly

If you get errors:
- Make sure you have Windows 10 or later
- Try running as Administrator
- Install Visual C++ Redistributables if needed

Files included:
- SDL3Game.exe (main executable)
- SDL3.dll (SDL3 library)
- MinGW runtime DLLs (libgcc, libstdc++, etc.)

Built on: $(date)
Target: Windows x64
Compiler: MinGW-w64
EOF

echo "Enhanced Windows package created in dist-windows/"
echo "Contents:"
ls -la dist-windows/

# Show dependency information
echo -e "\nExecutable dependencies:"
x86_64-w64-mingw32-objdump -p dist-windows/SDL3Game.exe | grep "DLL Name" | head -10