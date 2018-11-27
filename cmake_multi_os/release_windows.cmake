# every platfom need diferent c file
if (WIN32)
    list(APPEND project_sources "../windows/hid.c")
endif (WIN32)
