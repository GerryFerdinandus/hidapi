# every platfom need diferent c file
if (UNIX AND NOT APPLE)
    list(APPEND project_sources "../linux/hid.c")
endif (UNIX AND NOT APPLE)
