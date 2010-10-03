# Copyright (C) 2007-2009 LuaDist.
# Created by Peter Kapec
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

PROJECT(zziplib C)
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
INCLUDE(dist.cmake)


###########################################################################################
# generating config.h file:
MESSAGE("Configure: zziplib - generating config.h:")
	INCLUDE (CheckIncludeFiles)
	INCLUDE (CheckFunctionExists)
	INCLUDE (CheckSymbolExists)
	INCLUDE (CheckTypeSize)
	INCLUDE (TestBigEndian)

	#TODO:
	#/* Define if pointers to integers require aligned access */
	#undef HAVE_ALIGNED_ACCESS_REQUIRED


	CHECK_INCLUDE_FILES (byteswap.h ZZIP_HAVE_BYTESWAP_H)
	CHECK_INCLUDE_FILES (direct.h ZZIP_HAVE_DIRECT_H)
	CHECK_INCLUDE_FILES (dirent.h ZZIP_HAVE_DIRENT_H)
	CHECK_INCLUDE_FILES (dlfcn.h ZZIP_HAVE_DLFCN_H)
	CHECK_INCLUDE_FILES (fnmatch.h ZZIP_HAVE_FNMATCH_H)
	CHECK_INCLUDE_FILES (inttypes.h ZZIP_HAVE_INTTYPES_H)
	CHECK_INCLUDE_FILES (io.h ZZIP_HAVE_IO_H)
	CHECK_INCLUDE_FILES (memory.h ZZIP_HAVE_MEMORY_H)
	CHECK_INCLUDE_FILES (ndir.h ZZIP_HAVE_NDIR_H)
	CHECK_INCLUDE_FILES (stdint.h ZZIP_HAVE_STDINT_H)
	CHECK_INCLUDE_FILES (stdlib.h ZZIP_HAVE_STDLIB_H)
	CHECK_FUNCTION_EXISTS(strcasecmp ZZIP_HAVE_STRCASECMP)
	CHECK_INCLUDE_FILES (strings.h ZZIP_HAVE_STRINGS_H)
	CHECK_INCLUDE_FILES (string.h ZZIP_HAVE_STRING_H)
	CHECK_FUNCTION_EXISTS(strndup ZZIP_HAVE_STRNDUP)
	CHECK_INCLUDE_FILES ("sys/dir.h" ZZIP_HAVE_SYS_DIR_H)
	CHECK_INCLUDE_FILES ("sys/int_types.h" ZZIP_HAVE_SYS_INT_TYPES_H)
	CHECK_INCLUDE_FILES ("sys/mman.h" ZZIP_HAVE_SYS_MMAN_H)
	CHECK_INCLUDE_FILES ("sys/ndir.h" ZZIP_HAVE_SYS_NDIR_H)
	CHECK_INCLUDE_FILES ("sys/param.h" ZZIP_HAVE_SYS_PARAM_H)
	CHECK_INCLUDE_FILES ("sys/stat.h" ZZIP_HAVE_SYS_STAT_H)
	CHECK_INCLUDE_FILES ("sys/types.h" ZZIP_HAVE_SYS_TYPES_H)
	CHECK_INCLUDE_FILES (unistd.h ZZIP_HAVE_UNISTD_H)
	CHECK_INCLUDE_FILES (winbase.h ZZIP_HAVE_WINBASE_H)
	CHECK_INCLUDE_FILES (windows.h ZZIP_HAVE_WINDOWS_H)
	CHECK_INCLUDE_FILES (winnt.h ZZIP_HAVE_WINNT_H)

	#TODO:
	#CHECK_INCLUDE_FILES (zlib.h HAVE_ZLIB_H)
	SET(ZZIP_HAVE_ZLIB_H 1)

	#TODO:
	#/* whether the system defaults to 32bit off_t but can do 64bit when requested*/
	#undef LARGEFILE_SENSITIVE

	CHECK_TYPE_SIZE(int ZZIP_SIZEOF_INT)
	CHECK_TYPE_SIZE(long ZZIP_SIZEOF_LONG)
	CHECK_TYPE_SIZE(short ZZIP_SIZEOF_SHORT)
	CHECK_INCLUDE_FILES("stdlib.h;stdarg.h;string.h;float.h" ZZIP_STDC_HEADERS)

	TEST_BIG_ENDIAN(ZZIP_WORDS_BIGENDIAN)

	#TODO:
	#/* Number of bits in a file offset, on hosts where this is settable. */
	#undef _FILE_OFFSET_BITS

	#TODO:
	#/* Define for large files, on AIX-style hosts. */
	#undef _LARGE_FILES

	#/* Define to `long long' if <sys/types.h> does not define. */
	#undef __int64
	CHECK_SYMBOL_EXISTS(__int64 "sys/types.h" __INT64)
	IF( NOT __INT64 )
		SET(__INT64 "long long")
	ENDIF()

	#TODO:
	#/* Define to empty if `const' does not conform to ANSI C. */
	#undef const

	#TODO:
	#/* Define to `__inline__' or `__inline' if that's what the C compiler
	#   calls it, or to nothing if 'inline' is not supported under any name.  */
	#ifndef __cplusplus
	#undef inline
	#endif

	#/* Define to `_zzip_off_t' if <sys/types.h> does not define. */
	#undef off64_t
	#2DO: not working... 
	# cygwin MUST have: #define _zzip_off64_t _zzip_off_t
	# mingw - OK
#	CHECK_SYMBOL_EXISTS(off64_t "sys/types.h" OFF64_T)
#	IF( NOT OFF64_T )
#		SET(OFF64_T "_zzip_off_t")
#	ENDIF()

	#/* Define to `long int' if <sys/types.h> does not define. */
	#undef off_t
	CHECK_SYMBOL_EXISTS(off_t "sys/types.h" OFF_T)
	IF( NOT OFF_T )
		SET(OFF_T "long int")
	ENDIF()

	#TODO:
	#/* Define to equivalent of C99 restrict keyword, or to nothing if this is not
	#   supported. Do not define if restrict is supported directly. */
	#undef restrict
	#SET(RESTRICT "")

	#/* Define to `unsigned int' if <sys/types.h> does not define. */
	#undef size_t
	CHECK_SYMBOL_EXISTS(size_t "sys/types.h" SIZE_T)
	IF( NOT SIZE_T )
		SET(SIZE_T "unsigned int")
	ENDIF()

	#/* Define to `int' if <sys/types.h> does not define. */
	#undef ssize_t
	CHECK_SYMBOL_EXISTS(ssize_t "sys/types.h" SSIZE_T)
	IF( NOT SSIZE_T )
		SET(SSIZE_T "int")
	ENDIF()


# all is defined, so generate config.h
CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/_config.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/zzip/_config.h)

MESSAGE("Configure: zziplib - done.")
# end of generating config.h file:

ADD_DEFINITIONS(-DHAVE_CONFIG_H )
INCLUDE_DIRECTORIES (${CMAKE_CURRENT_BINARY_DIR})

###########################################################################################

# Zlib library needed
FIND_PACKAGE(ZLIB REQUIRED)
INCLUDE_DIRECTORIES(${ZLIB_INCLUDE_DIR})

# libzlib library
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
SET(ZZIPLIB_SRCS
	zzip/dir.c
	zzip/err.c
	zzip/file.c
	zzip/info.c
	zzip/plugin.c
	zzip/stat.c
	zzip/write.c
	zzip/zip.c
	)

IF(MSVC)
	SET(DEF_FILE libzziplib.def)
ENDIF()

ADD_LIBRARY(zziplib SHARED ${ZZIPLIB_SRCS} ${DEF_FILE})
TARGET_LINK_LIBRARIES(zziplib ${ZLIB_LIBRARIES} )

# Install module
INSTALL(TARGETS zziplib DESTINATION ${INSTALL_LIB})

# Install headers
INSTALL(FILES zzip/zzip.h zzip/types.h zzip/conf.h zzip/_msvc.h ${CMAKE_CURRENT_BINARY_DIR}/zzip/_config.h DESTINATION ${INSTALL_INC}/zzip)

# Install documentation
INSTALL(DIRECTORY docs/ DESTINATION ${INSTALL_DOC}
		PATTERN *.am EXCLUDE
		PATTERN *.in EXCLUDE
		PATTERN *.pl EXCLUDE
		PATTERN *.py EXCLUDE
		PATTERN *.sh EXCLUDE
		)

INSTALL(FILES ChangeLog README TODO DESTINATION ${INSTALL_DATA})
