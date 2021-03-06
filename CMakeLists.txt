# This is an Gray-Scott project to show and test the usage of the FindOpenCL
# script.

cmake_minimum_required( VERSION 2.6 )
project( Gray-Scott )

# This is only required for the script to work in the version control
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/../..")

find_package( OpenCL REQUIRED )

include_directories( ${OPENCL_INCLUDE_DIRS} )

if( OPENCL_HAS_CPP_BINDINGS )
	message( "OpenCL has CPP bindings. Full include is: " ${OPENCL_INCLUDE_DIRS} )
else( OPENCL_HAS_CPP_BINDINGS )
	message( "No OpenCL CPP bindings found" )
endif( OPENCL_HAS_CPP_BINDINGS )


add_executable( Gray-Scott
                Main_Program.cpp
		Device_Utilities.cpp)

target_link_libraries( Gray-Scott ${OPENCL_LIBRARIES} )

# Generating the data folder where the model stores its results
file(MAKE_DIRECTORY ./build/Data)

# Defining the "run" command (use as: make run) that runs the model
add_custom_target(run ./Gray-Scott)

# Defining the “destroy: command (use as: make wipe) that clears the build folder
add_custom_target(destroy rm -rf ../build/*
                  COMMENT “Clears_the_build_directory”)
