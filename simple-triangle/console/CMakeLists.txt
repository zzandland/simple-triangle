cmake_minimum_required(VERSION 3.4.1)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++20 -fexceptions")
project(simple-triangle-console)

# set variables to shared libraries and source codes
set(THIRD_PARTY_DIR "../../third-party")
set(MAIN_SOURCE_DIR "../main/src")

# build output to 'out'
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/out)

# 
list(APPEND CMAKE_FRAMEWORK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Frameworks")

# include SDL header files
include_directories(${THIRD_PARTY_DIR}/SDL/include)

# recursively collate all 
file(GLOB_RECURSE CPP_HEADERS ${MAIN_SOURCE_DIR}/*.h)
file(GLOB_RECURSE CPP_SOURCES ${MAIN_SOURCE_DIR}/*.cc)

# generate a C++ executable from the source code
add_executable(
    simple-triangle-console
    ${CPP_HEADERS}
    ${CPP_SOURCES}
)

# Link external framework (SDL and OpenGL)
set_target_properties(
    simple-triangle-console
    PROPERTIES
    LINK_FLAGS
    "-F../Frameworks -framework SDL2 -framework OpenGL"
)

# Run post make script
add_custom_command(
    TARGET simple-triangle-console
    POST_BUILD
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMAND ./cmake-post-build.sh
)
