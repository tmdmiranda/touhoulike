@echo off
echo Starting SDL3 Game...
SDL3Game.exe
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Game exited with error code: %ERRORLEVEL%
    echo Press any key to close...
    pause >nul
)
