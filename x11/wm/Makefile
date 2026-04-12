# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

.POSIX:

include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: dwm

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f dwm ${OBJ} dwm_farajli-$(VERSION).tar.gz *.rej *.orig

dist: clean
	mkdir -p dwm_farajli-$(VERSION)
	cp -R LICENSE Makefile README config.mk\
		dwm.1 drw.h util.h config.h ${SRC} transient.c dwm_farajli-$(VERSION)
	tar -czf dwm_farajli-$(VERSION).tar.gz dwm_farajli-$(VERSION)
	rm -rf dwm_farajli-$(VERSION)

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1

.PHONY: all clean dist install uninstall
