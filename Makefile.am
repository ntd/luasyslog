rock=			$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)-1.src.rock
rockspec=		$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)-1.rockspec
c_sources=		lsyslog.c
lua_sources=		syslog.lua

EXTRA_DIST=		README \
			COPYING \
			Makefile.am \
			luasyslog.rockspec.in \
			$(c_sources) \
			$(lua_sources) \
			$(LMOD) \
			$(TESTS) \
			build/ax_define_subst.m4 \
			build/ax_lua.m4

TESTS=			test.lua
CLEANFILES=		$(rock)

ACLOCAL_AMFLAGS=	-I build
AM_CPPFLAGS=		$(LUA_INCLUDE)
LIBADD=			$(LUA_LIB)


luaexec_LTLIBRARIES=	lsyslog.la
lsyslog_la_SOURCES=	$(c_sources)
lsyslog_la_LDFLAGS=	-module

syslogdir=		$(luadir)/syslog
syslog_SCRIPTS=		$(lua_sources)


rock: $(rock)

$(rock): $(rockspec)
	$(AT_GEN)$(LUAROCKS) pack $<


.PHONY: rock
