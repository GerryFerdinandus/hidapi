# every platfom need diferent c file
if (APPLE)
    list(APPEND project_sources "../mac/hid.c")
endif (APPLE)
