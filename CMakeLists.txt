# Copyright (C) 2007-2012 LuaDist.
# Created by Peter Kapec
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

project ( zziplib C )
cmake_minimum_required ( VERSION 2.8 )
include ( cmake/dist.cmake )

###########################################################################################
# generating config.h file:
message ( "Configure: zziplib - generating config.h:" )
include ( CheckIncludeFiles )
include ( CheckFunctionExists )
include ( CheckSymbolExists )
include ( CheckTypeSize )
include ( TestBigEndian )

#TODO:
#/* Define if pointers to integers require aligned access */
#undef HAVE_ALIGNED_ACCESS_REQUIRED

check_include_files ( byteswap.h ZZIP_HAVE_BYTESWAP_H )
check_include_files ( direct.h ZZIP_HAVE_DIRECT_H )
check_include_files ( dirent.h ZZIP_HAVE_DIRENT_H )
check_include_files ( dlfcn.h ZZIP_HAVE_DLFCN_H )
check_include_files ( fnmatch.h ZZIP_HAVE_FNMATCH_H )
check_include_files ( inttypes.h ZZIP_HAVE_INTTYPES_H )
check_include_files ( io.h ZZIP_HAVE_IO_H )
check_include_files ( memory.h ZZIP_HAVE_MEMORY_H )
check_include_files ( ndir.h ZZIP_HAVE_NDIR_H )
check_include_files ( stdint.h ZZIP_HAVE_STDINT_H )
check_include_files ( stdlib.h ZZIP_HAVE_STDLIB_H )
check_function_exists ( strcasecmp ZZIP_HAVE_STRCASECMP )
check_include_files ( strings.h ZZIP_HAVE_STRINGS_H )
check_include_files ( string.h ZZIP_HAVE_STRING_H )
check_function_exists ( strndup ZZIP_HAVE_STRNDUP )
check_include_files ( "sys/dir.h" ZZIP_HAVE_SYS_DIR_H )
check_include_files ( "sys/int_types.h" ZZIP_HAVE_SYS_INT_TYPES_H )
check_include_files ( "sys/mman.h" ZZIP_HAVE_SYS_MMAN_H )
check_include_files ( "sys/ndir.h" ZZIP_HAVE_SYS_NDIR_H )
check_include_files ( "sys/param.h" ZZIP_HAVE_SYS_PARAM_H )
check_include_files ( "sys/stat.h" ZZIP_HAVE_SYS_STAT_H )
check_include_files ( "sys/types.h" ZZIP_HAVE_SYS_TYPES_H )
check_include_files ( unistd.h ZZIP_HAVE_UNISTD_H )
check_include_files ( winbase.h ZZIP_HAVE_WINBASE_H )
check_include_files ( windows.h ZZIP_HAVE_WINDOWS_H )
check_include_files ( winnt.h ZZIP_HAVE_WINNT_H )

#TODO:
#CHECK_INCLUDE_FILES (zlib.h HAVE_ZLIB_H)
set ( ZZIP_HAVE_ZLIB_H 1 )

#TODO:
#/* whether the system defaults to 32bit off_t but can do 64bit when requested*/
#undef LARGEFILE_SENSITIVE

check_type_size ( int ZZIP_SIZEOF_INT )
check_type_size ( long ZZIP_SIZEOF_LONG )
check_type_size ( short ZZIP_SIZEOF_SHORT )
check_include_files ( "stdlib.h;stdarg.h;string.h;float.h" ZZIP_STDC_HEADERS )

test_big_endian ( ZZIP_WORDS_BIGENDIAN )

#TODO:
#/* Number of bits in a file offset, on hosts where this is settable. */
#undef _FILE_OFFSET_BITS

#TODO:
#/* Define for large files, on AIX-style hosts. */
#undef _LARGE_FILES

#/* Define to `long long' if <sys/types.h> does not define. */
#undef __int64
check_symbol_exists ( __int64 "sys/types.h" __INT64 )
if ( NOT __INT64 )
  set ( __INT64 "long long" )
endif ( )

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
check_symbol_exists ( off_t "sys/types.h" OFF_T )
if ( NOT OFF_T )
  set ( OFF_T "long int" )
endif ( )

#TODO:
#/* Define to equivalent of C99 restrict keyword, or to nothing if this is not
#   supported. Do not define if restrict is supported directly. */
#undef restrict
#SET(RESTRICT "")

#/* Define to `unsigned int' if <sys/types.h> does not define. */
#undef size_t
check_symbol_exists ( size_t "sys/types.h" SIZE_T )
if ( NOT SIZE_T )
  set ( SIZE_T "unsigned int" )
endif ( )

#/* Define to `int' if <sys/types.h> does not define. */
#undef ssize_t
check_symbol_exists ( ssize_t "sys/types.h" SSIZE_T )
if ( NOT SSIZE_T )
  set ( SSIZE_T "int" )
endif ( )

# all is defined, so generate config.h
configure_file ( ${CMAKE_CURRENT_SOURCE_DIR}/_config.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/zzip/_config.h )

message ( "Configure: zziplib - done." )
# end of generating config.h file:

add_definitions ( -DHAVE_CONFIG_H )
include_directories ( ${CMAKE_CURRENT_BINARY_DIR} )

###########################################################################################

# Zlib library needed
find_package ( ZLIB REQUIRED )
include_directories ( ${ZLIB_INCLUDE_DIR} )

# libzlib library
include_directories ( ${CMAKE_CURRENT_SOURCE_DIR} )
set ( ZZIPLIB_SRCS zzip/dir.c zzip/err.c zzip/file.c zzip/info.c zzip/plugin.c zzip/stat.c 
  zzip/write.c zzip/zip.c )

if ( MSVC )
  set ( DEF_FILE libzziplib.def )
endif ( )

add_library ( zziplib ${ZZIPLIB_SRCS} ${DEF_FILE} )
target_link_libraries ( zziplib ${ZLIB_LIBRARIES} )

# Install module
install_library ( zziplib )

# Install headers
install_header ( zzip/zzip.h zzip/types.h zzip/conf.h zzip/_msvc.h ${CMAKE_CURRENT_BINARY_DIR}/zzip/_config.h INTO zzip )

# Install documentation
install_doc ( docs/ )

install_data ( ChangeLog README TODO )
