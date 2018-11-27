cmake_minimum_required(VERSION 3.5.1)
message(STATUS "===============================================")
message(STATUS "Create DLL build.")
message(STATUS "===============================================")

#The name of this DLL project
set(name_test_project hid_interface)

#project name
project(${name_test_project})

# now include only the OS specific item.
if (WIN32)
    include(release_windows.cmake)
endif (WIN32)

if (UNIX AND NOT APPLE)
    include(release_linux.cmake)
endif (UNIX AND NOT APPLE)

if (APPLE)
    include(release_macos.cmake)
endif (APPLE)

#create an DLL
add_library (${name_test_project} SHARED ${project_sources})

#the include the hidapi headers
include_directories(../hidapi)


if (WIN32)
    #the include the WINDOWS library needed for hid
    target_link_libraries(${name_test_project} hid setupapi)

    # Remove @nn from exported symbols -Wl,--enable-stdcall-fixup
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}  -Wl,--kill-at")
endif (WIN32)

if (UNIX AND NOT APPLE)
    #the include the LINUX library needed for hid
    target_link_libraries(${name_test_project} libudev.so)
endif (UNIX AND NOT APPLE)

if (APPLE)
    #the include the macOS library needed for hid
    find_library(CoreFoundation CoreFoundation)
    find_library(IOKit IOKit)
    target_link_libraries(${name_test_project} ${IOKit} ${CoreFoundation})
endif (APPLE)

if (WIN32)
    #include all the static library for windows executable. In unix we use shared library.
    #this is needed if we want to run the test via dos console.
    #recomendend to run test in Linux with all the -sanatize setting.
    # -sanatize is not suported in windows
    target_link_libraries(${name_test_project} -static)
endif (WIN32)





