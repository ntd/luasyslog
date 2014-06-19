rock=			$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)-1.src.rock
rockspec=		$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)-1.rockspec
c_sources=		lsyslog.c
lua_sources=		syslog.lua

EXTRA_DIST=		autogen.sh \
			README \
			COPYING \
			Makefile.am \
			test.lua.in \
			luasyslog.rockspec.in \
			$(c_sources) \
			$(lua_sources) \
			$(LMOD) \
			build/ax_define_subst.m4 \
			build/ax_lua.m4

TESTS=			test.lua
dist_data_DATA=		example.lua

ACLOCAL_AMFLAGS=	-I build
AM_CPPFLAGS=		-I. $(LUA_INCLUDE)
LIBADD=			$(LUA_LIB)


luaexec_LTLIBRARIES=	lsyslog.la
lsyslog_la_SOURCES=	$(c_sources)
lsyslog_la_LDFLAGS=	-module

loggingdir=		$(luadir)/logging
logging_DATA=		$(lua_sources)

CLEANFILES=		$(rock)


rock: $(rock)

$(rock): $(rockspec)
	$(AT_GEN)$(LUAROCKS) pack $<


.PHONY: rock
