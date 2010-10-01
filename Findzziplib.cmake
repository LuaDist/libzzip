# Copyright (C) 2007-2009 LuaDist.
# Created by Peter Kapec <kapecp@gmail.com>
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
#	Note:
#		Searching headers and libraries is very simple and is NOT as powerful as scripts
#		distributed with CMake, because LuaDist defines directories to search for.
#		Everyone is encouraged to contact the author with improvements. Maybe this file
#		becomes part of CMake distribution sometimes.

# - Find zziplib
# Find the native ZZIPLIB headers and libraries.
#
# ZZIPLIB_INCLUDE_DIRS	- where to find zzip/zzip.h, etc.
# ZZIPLIB_LIBRARIES	- List of libraries when using zziplib.
# ZZIPLIB_FOUND	- True if zziplib found.

# Look for the header file.
FIND_PATH(ZZIPLIB_INCLUDE_DIR NAMES zzip/zzip.h)

# Look for the library.
FIND_LIBRARY(ZZIPLIB_LIBRARY NAMES zziplib)

# Handle the QUIETLY and REQUIRED arguments and set ZZIPLIB_FOUND to TRUE if all listed variables are TRUE.
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ZZIPLIB DEFAULT_MSG ZZIPLIB_LIBRARY ZZIPLIB_INCLUDE_DIR)

# Copy the results to the output variables.
IF(ZZIPLIB_FOUND)
	SET(ZZIPLIB_LIBRARIES ${ZZIPLIB_LIBRARY})
	SET(ZZIPLIB_INCLUDE_DIRS ${ZZIPLIB_INCLUDE_DIR})
ELSE(ZZIPLIB_FOUND)
	SET(ZZIPLIB_LIBRARIES)
	SET(ZZIPLIB_INCLUDE_DIRS)
ENDIF(ZZIPLIB_FOUND)

MARK_AS_ADVANCED(ZZIPLIB_INCLUDE_DIRS ZZIPLIB_LIBRARIES)
