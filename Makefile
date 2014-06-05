PACKAGE = luasyslog
PACKAGE_VERSION = 2.0.0
PACKAGE_DESCRIPTION = syslog appender for LuaLogging
PACKAGE_AUTHOR = Nicola Fontana <ntd@entidi.it>
PACKAGE_LICENSE = MIT/X11
PACKAGE_TARNAME = $(PACKAGE)-$(PACKAGE_VERSION)

TEMPLATE = luasyslog.rockspec.in
ROCKSPEC = $(PACKAGE_TARNAME)-1.rockspec
ROCK = $(PACKAGE_TARNAME)-1.src.rock
TARBALL = $(PACKAGE_TARNAME).tar.gz
SOURCES = lsyslog.c
OBJS = lsyslog.o
CMOD = lsyslog.so
LMOD = syslog.lua
TESTS = test.lua
DISTFILES = README COPYING Makefile $(SOURCES) $(LMOD) $(TEMPLATE) $(TESTS)

LUA = lua
CC = gcc
TAR = tar
PKG_CONFIG = pkg-config
SED = sed
LUAROCKS = luarocks

LUA_PACKAGE = lua
CFLAGS = `$(PKG_CONFIG) --cflags $(LUA_PACKAGE)` -O2 -fpic
CPPFLAGS = -DPACKAGE='"$(PACKAGE)"' \
	   -DPACKAGE_VERSION='"$(PACKAGE_VERSION)"' \
	   -DPACKAGE_DESCRIPTION='"$(PACKAGE_DESCRIPTION)"' \
	   -DPACKAGE_AUTHOR='"$(PACKAGE_AUTHOR)"' \
	   -DPACKAGE_LICENSE='"$(PACKAGE_LICENSE)"' \
	   -DPACKAGE_TARNAME='"$(PACKAGE_TARNAME)"'
LIBFLAG = `$(PKG_CONFIG) --libs $(LUA_PACKAGE)` -O -fpic -shared
LUADIR = $(DESTDIR)`$(PKG_CONFIG) --variable=INSTALL_LMOD $(LUA_PACKAGE)`
LIBDIR = $(DESTDIR)`$(PKG_CONFIG) --variable=INSTALL_CMOD $(LUA_PACKAGE)`

# Silent rules: use "make V=1" for verbose mode
V = 0
AT = $(AT_$(V))
AT_0 = @
AT_1 =
AT_GEN = $(AT_GEN_$(V))
AT_GEN_0 = @echo "  GEN     " $@;
AT_GEN_1 =
AT_CC = $(AT_CC_$(V))
AT_CC_0 = @echo "  CC      " $@;
AT_CC_1 =
AT_CCLD = $(AT_CCLD_$(V))
AT_CCLD_0 = @echo "  CCLD    " $@;
AT_CCLD_1 =


all: $(CMOD) $(LMOD)

$(CMOD): $(OBJS)
	$(AT_CCLD)$(CC) $(LIBFLAG) -o $(CMOD) $(OBJS)

.c.o:
	$(AT_CC)$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@


dist: $(TARBALL)
	$(AT)rm -fr "$(PACKAGE_TARNAME)"

$(TARBALL): $(PACKAGE_TARNAME)
	$(AT_GEN)$(TAR) czf $@ $</

$(PACKAGE_TARNAME): $(DISTFILES)
	$(AT_GEN)rm -fr "$(PACKAGE_TARNAME)" ; \
	test -d "$(PACKAGE_TARNAME)" || mkdir "$(PACKAGE_TARNAME)"; \
	for file in $(DISTFILES); do \
	    test -f "$(PACKAGE_TARNAME)/$$file" \
	    || cp -p $$file "$(PACKAGE_TARNAME)/$$file" \
	    || exit 1; \
	done


rock: $(ROCK)

rockspec: $(ROCKSPEC)

$(ROCK): $(ROCKSPEC)
	$(AT_GEN)$(LUAROCKS) pack $<

$(ROCKSPEC): $(TEMPLATE)
	$(AT_GEN)$(SED) \
	    -e 's|@PACKAGE@|$(PACKAGE)|g' \
	    -e 's|@PACKAGE_VERSION@|$(PACKAGE_VERSION)|g' \
	    -e 's|@PACKAGE_DESCRIPTION@|$(PACKAGE_DESCRIPTION)|g' \
	    -e 's|@PACKAGE_AUTHOR@|$(PACKAGE_AUTHOR)|g' \
	    -e 's|@PACKAGE_LICENSE@|$(PACKAGE_LICENSE)|g' \
	    -e 's|@PACKAGE_TARNAME@|$(PACKAGE_TARNAME)|g' \
	$< > $@


install: install-lmod install-cmod

install-cmod: $(CMOD)
	$(AT)install -d $(LIBDIR)/ ; \
	install -m0755 $< $(LIBDIR)

install-lmod: $(LMOD)
	$(AT)install -d $(LUADIR)/logging/ ; \
	install -m0644 $< $(LUADIR)/logging/

uninstall:
	$(AT)rm -f $(LIBDIR)/$(CMOD) $(LUADIR)/logging/$(LMOD)


clean:
	$(AT)rm -f $(OBJS) $(CMOD)

clean-rock:
	$(AT)rm -f $(ROCK) $(ROCKSPEC)

distclean: clean clean-rock
	$(AT)rm -f $(TARBALL) ; \
	rm -fr $(PACKAGE_TARNAME)/


check: $(TESTS) $(CMOD) $(LMOD)
	$(AT)$(LUA) test.lua


.PHONY: all dist rock rockspec \
	install install-cmod install-lmod uninstall \
	clean clean-rock distclean
