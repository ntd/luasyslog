PACKAGE = luasyslog
VERSION = 1.1.0
TARNAME = $(PACKAGE)-$(VERSION)

TEMPLATE = luasyslog.rockspec.in
ROCKSPEC = $(TARNAME)-1.rockspec
ROCK = $(TARNAME)-1.src.rock
TARBALL = $(TARNAME).tar.gz
SOURCES = lsyslog.c
OBJS = lsyslog.o
CMOD = lsyslog.so
LMOD = syslog.lua
DISTFILES = README COPYING Makefile $(SOURCES) $(LMOD) $(TEMPLATE)

CC = gcc
TAR = tar
PKG_CONFIG = pkg-config
SED = sed
LUAROCKS = luarocks

CFLAGS = `$(PKG_CONFIG) --cflags lua` -O2 -fpic
LIBFLAG = `$(PKG_CONFIG) --libs lua` -O -fpic -shared
LUADIR = $(DESTDIR)`$(PKG_CONFIG) --variable=INSTALL_LMOD lua`
LIBDIR = $(DESTDIR)`$(PKG_CONFIG) --variable=INSTALL_CMOD lua`

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
	$(AT_CC)$(CC) $(CFLAGS) -c $< -o $@


dist: $(TARBALL)
	$(AT)rm -fr "$(TARNAME)"

$(TARBALL): $(TARNAME)
	$(AT_GEN)$(TAR) czf $@ $</

$(TARNAME): $(DISTFILES)
	$(AT_GEN)rm -fr "$(TARNAME)" ; \
	test -d "$(TARNAME)" || mkdir "$(TARNAME)"; \
	for file in $(DISTFILES); do \
	    test -f "$(TARNAME)/$$file" \
	    || cp -p $$file "$(TARNAME)/$$file" \
	    || exit 1; \
	done


rock: $(ROCK)

rockspec: $(ROCKSPEC)

$(ROCK): $(ROCKSPEC)
	$(AT_GEN)$(LUAROCKS) pack $<

$(ROCKSPEC): $(TEMPLATE)
	$(AT_GEN)$(SED) -e 's/@VERSION@/$(VERSION)/g' $< > $@


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
	rm -fr $(TARNAME)/


.PHONY: all dist rock rockspec \
	install install-cmod install-lmod uninstall \
	clean clean-rock distclean
