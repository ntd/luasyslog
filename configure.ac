dnl autoconf initialization
AC_INIT([luasyslog],
	[2.0.3],
	[http://github.com/ntd/luasyslog/issues/],
	[luasyslog],
	[https://github.com/ntd/luasyslog/])

AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([build])

dnl automake initialization
AM_INIT_AUTOMAKE([foreign])
m4_ifdef([AM_SILENT_RULES],
         [AM_SILENT_RULES([yes])],
         [AC_SUBST([AM_V_GEN],[])])

dnl libtool initialization
LT_INIT([disable-static win32-dll])

dnl Additional package metadata
AX_DEFINE_SUBST([PACKAGE_DESCRIPTION],["syslog appender for LuaLogging"],
		[Description of the package.])
AX_DEFINE_SUBST([PACKAGE_AUTHOR],["Nicola Fontana <ntd@entidi.it>"],
		[Name and email of the actual package maintainer.])
AX_DEFINE_SUBST([PACKAGE_LICENSE],["MIT/X11"],
		[License under which this software has been released.])

dnl Check for programs
AC_PROG_CC
AC_PROG_SED
AC_PATH_PROG([LUAROCKS], [luarocks], [:])
AX_PROG_LUA([5.1], [5.3])

dnl Check for libraries
AX_LUA_LIBS

dnl Check for functions
AC_HEADER_STDC
AC_CHECK_HEADERS([syslog.h])
AC_CHECK_FUNCS([strdup])
AX_LUA_HEADERS

dnl File generation
AC_CONFIG_HEADER(config.h)
AC_CONFIG_FILES([Makefile]
		luasyslog-AC_PACKAGE_VERSION-1.rockspec:luasyslog.rockspec.in)
AC_CONFIG_FILES([test.lua],[chmod 0755 test.lua])
AC_OUTPUT
