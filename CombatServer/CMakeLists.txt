cmake_minimum_required(VERSION 2.6)

project(CombatServer)


# The version number.
set (CombatServer_VERSION_MAJOR 0)
set (CombatServer_VERSION_MINOR 5)


# add the binary tree to the search path for include files
add_subdirectory (raknet4_0802/Source)
# add_subdirectory (ReplicaManager)

aux_source_directory(./ReplicaManager/ REPLICA_MANAGER_SRCS)
aux_source_directory(./GameObject/ GAME_OBJECT_SRCS)

include_directories(.)
# include files
IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
	# Mac OS X specific code
	SET(OperatingSystem "Mac OS X")
	include_directories(/usr/local/include/raknet)
ELSE()
	# Mac OS X specific code
	include_directories(/usr/include/raknet)
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

# add the executable
add_executable(CombatServer CombatServer.cpp ${REPLICA_MANAGER_SRCS} ${GAME_OBJECT_SRCS})

IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
target_link_libraries (CombatServer 
	/usr/local/lib/libraknet.dylib
	pthread)
ELSE()
target_link_libraries (CombatServer 
	/usr/lib/libraknet.so
	pthread)
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

