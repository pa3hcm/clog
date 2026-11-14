# Makefile for CLog
#
#   make test                    run the tests in t/
#   sudo make install            install clog and its man page in /usr/local
#   make install PREFIX=~/.local install somewhere else
#   sudo make uninstall          remove them again
#
# DESTDIR is supported for packaging (make install DESTDIR=/tmp/pkg).

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1

.PHONY: all test install uninstall

all:
	@echo "Nothing to build. Use 'make test' or 'make install'."

test:
	prove t/

install:
	install -d $(DESTDIR)$(BINDIR) $(DESTDIR)$(MANDIR)
	install -m 755 bin/clog $(DESTDIR)$(BINDIR)/clog
	gzip -9n -c man/clog.1 > $(DESTDIR)$(MANDIR)/clog.1.gz
	chmod 644 $(DESTDIR)$(MANDIR)/clog.1.gz

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/clog $(DESTDIR)$(MANDIR)/clog.1.gz
