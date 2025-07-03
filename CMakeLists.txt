cmake_minimum_required(VERSION 3.20)
project(SDL3Game VERSION 1.0.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Compiler flags
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(-g -O0 -Wall -Wextra)
else()
    add_compile_options(-O3 -DNDEBUG)
endif()

# Find SDL3 based on platform
if(CMAKE_CROSSCOMPILING AND WIN32)
    # Cross-compiling for Windows
    set(SDL3_DIR "${CMAKE_SOURCE_DIR}/third-party/sdl3-windows/lib/cmake/SDL3")
    message(STATUS "Cross-compiling for Windows, using SDL3 from: ${SDL3_DIR}")
else()
    # Native Linux build
    set(SDL3_DIR "${CMAKE_SOURCE_DIR}/third-party/sdl3-linux/lib/cmake/SDL3")
    message(STATUS "Native Linux build, using SDL3 from: ${SDL3_DIR}")
endif()

# Try to find SDL3
find_package(SDL3 REQUIRED)

if(NOT TARGET SDL3::SDL3)
    message(FATAL_ERROR "SDL3::SDL3 target not found. Please run setup-sdl3-cross.sh first.")
endif()

# Include directories
include_directories(${CMAKE_SOURCE_DIR}/include)

# Source files
file(GLOB_RECURSE SOURCES "src/*.cpp" "src/*.c")
file(GLOB_RECURSE HEADERS "include/*.h" "include/*.hpp")

# Create executable
add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})

# Link libraries
target_link_libraries(${PROJECT_NAME} SDL3::SDL3)

# Platform-specific settings
if(WIN32)
    # Windows-specific settings
    set_target_properties(${PROJECT_NAME} PROPERTIES
        WIN32_EXECUTABLE FALSE  # Set to TRUE if you want a Windows app (no console)
    )
    
    # Link additional Windows libraries if needed
    target_link_libraries(${PROJECT_NAME} 
        -static-libgcc 
        -static-libstdc++
    )
endif()

# Copy assets
if(EXISTS "${CMAKE_SOURCE_DIR}/assets")
    file(COPY ${CMAKE_SOURCE_DIR}/assets DESTINATION ${CMAKE_BINARY_DIR})
endif()

# Install
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)

# Install SDL3 DLLs on Windows
if(WIN32 AND CMAKE_CROSSCOMPILING)
    install(FILES 
        "${CMAKE_SOURCE_DIR}/third-party/sdl3-windows/bin/SDL3.dll"
        DESTINATION bin
    )
endif()
