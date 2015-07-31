cmake_minimum_required(VERSION 2.6)

project(RAKNET_LIB)

aux_source_directory(. RAKNET_SRCS)

add_library(raknet SHARED ${RAKNET_SRCS})
set_target_properties(raknet PROPERTIES VERSION 1.0.0 SOVERSION 1)

install(TARGETS raknet
	LIBRARY DESTINATION lib) 
install(DIRECTORY .
       DESTINATION include/raknet
       FILES_MATCHING PATTERN "*.h") 

