CC := gcc
CFLAGS :=
LIBS :=
LDFLAGS :=
override CFLAGS += `pkg-config --cflags gtk+-2.0` -I. $(RPM_OPT_FLAGS)
override LIBS += `pkg-config --libs gtk+-2.0`
bindir ?= /usr/bin
datadir ?= /usr/share
mandir ?= /usr/share/man/man1
enable_nls ?= 1

.c.o:
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $<

all: 
	make gperiodic
	make -C po/ all enable_nls=$(enable_nls)
	intltool-merge -d po gperiodic.desktop.in gperiodic.desktop

gperiodic: gperiodic.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o gperiodic gperiodic.o $(LIBS)
ifeq ($(strip),1)
	strip gperiodic
endif

gpdata.o: gpdata.c gperiodic.h

gperiodic.o: gperiodic.c gperiodic.h table_data.h

install:
	mkdir -p $(DESTDIR)$(bindir)
	install -m 755 gperiodic $(DESTDIR)$(bindir)
	mkdir -p $(DESTDIR)$(datadir)/applications
	install -m 644 gperiodic.desktop $(DESTDIR)$(datadir)/applications
	mkdir -p $(DESTDIR)$(datadir)/pixmaps
	install -m 644 icons/gperiodic.png $(DESTDIR)$(datadir)/pixmaps
	install -m 644 icons/gperiodic.xpm $(DESTDIR)$(datadir)/pixmaps
	mkdir -p $(DESTDIR)$(mandir)
	install -m 644 gperiodic.1 $(DESTDIR)$(mandir)
	make -C po/ install enable_nls=$(enable_nls) datadir=$(datadir) DESTDIR=$(DESTDIR)

uninstall:
	rm -f $(bindir)/gperiodic \
	      $(datadir)/applications/gperiodic.desktop \
	      $(datadir)/pixmaps/gperiodic.png \
	      $(datadir)/pixmaps/gperiodic.xpm \
	      $(mandir)/gperiodic.1
	make -C po/ uninstall enable_nls=$(enable_nls) datadir=$(datadir) DESTDIR=$(DESTDIR)

clean:
	rm -f *.o gperiodic gperiodic.desktop
	make -C po/ clean

.PHONY: install uninstall clean
