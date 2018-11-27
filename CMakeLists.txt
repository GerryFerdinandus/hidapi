#ubuntu 14.04 "apt-get install cmake3" (will install version 3.5.1)
cmake_minimum_required(VERSION 3.5.1)

# the project name is HID_LIBRARY
if (NOT NAMESPACE_HID_LIBRARY)
    #must be uppercase
    set(NAMESPACE_HID_LIBRARY "HID_LIBRARY")
endif ()

# this is a C project
project(${NAMESPACE_HID_LIBRARY} C)


#Use all diferent sanitize options
# warning: -fsanitize=address and -fsanitize=kernel-address are incompatible with -fsanitize=thread
#-fsanitize=leak need special library https://github.com/google/sanitizers/wiki/AddressSanitizerLeakSanitizer
#
# Must disabled sanatize if Valgrind is being used
#set(USE_SANITIZE_INTRUMENTATION_GCC "-fsanitize=address -fsanitize=undefined  -fsanitize=leak")
set(USE_SANITIZE_THREAD_GCC "-fsanitize=thread -fPIE -pie")

# Clang only? -> -fsanitize=memory
#set(USE_SANITIZE_INTRUMENTATION_CLANG "-fsanitize=address -fsanitize=undefined  -fsanitize=leak -fsanitize=memory")
set(USE_SANITIZE_THREAD_CLANG "-fsanitize=thread")

# Debug compiler flags use for the unit testing build.
# please try to keep entries ordered
# -Wno-unknown-attributes -Wnon-virtual-dtor
set(COMPILER_FLAGS_WARNING "-Wall -Wcast-align -Wconversion -Wctor-dtor-privacy -Werror -Wextra -Wno-missing-braces -Woverloaded-virtual -Wpedantic -Wshadow -Wsign-conversion -Wcast-qual -Wswitch-default")
set(COMPILER_FLAGS_MISC "-fno-omit-frame-pointer -fno-strict-aliasing -g")
set(COMPILER_OPTIMIZER_ON "-O2")
set(COMPILER_OPTIMIZER_OFF "-O0")

#  Possible values are empty, Debug, Release, RelWithDebInfo and MinSizeRel.
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    list(APPEND BUILD_TEXT "This is a CMake DEBUG build mode.")
endif ()

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    list(APPEND BUILD_TEXT "This is a CMake RELEASE build mode.")
endif ()

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(COMPILER_OPTIMIZER ${COMPILER_OPTIMIZER_OFF})
else ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(COMPILER_OPTIMIZER ${COMPILER_OPTIMIZER_ON})
endif ()

# Add all the flags together.
set(COMPILER_FLAGS "${COMPILER_FLAGS_WARNING} ${COMPILER_FLAGS_MISC} ${COMPILER_OPTIMIZER} ${USE_SANITIZE_INTRUMENTATION}")
message(STATUS "===============================================")
string(REPLACE ";" "\n" BUILD_TEXT "${BUILD_TEXT}")
message(STATUS "${BUILD_TEXT}")
message(STATUS "All compiler build flags: ${COMPILER_FLAGS}")
message(STATUS "===============================================")


# Set the output folder where your program will be created (/bin)
#
# Folder path for generated executables
#
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)

#
# Folder path for generated libraries
#
set(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)

# only in release buld we have DLL file
#if (CMAKE_BUILD_TYPE STREQUAL "Release")
# Create the library (DLL)
add_subdirectory(cmake_multi_os)
#endif ()

# only in release build create the doxygen files
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    #add doxygen generation
    include(cmake/doxygen.cmake)
endif ()


