PREFIX ?= /usr/local

.PHONY: all test check lint deb install uninstall clean

all:

check:
	bash tests/smoke.sh --quick

test:
	bash tests/smoke.sh

lint:
	shellcheck vidscribe tests/smoke.sh

deb:
	dpkg-buildpackage -us -uc -b
	lintian --fail-on error,warning ../vidscribe_*_all.deb

install:
	install -Dm755 vidscribe $(DESTDIR)$(PREFIX)/bin/vidscribe
	install -Dm644 vidscribe.1 $(DESTDIR)$(PREFIX)/share/man/man1/vidscribe.1
	install -Dm644 vidscribe.svg $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps/vidscribe.svg

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/vidscribe \
	      $(DESTDIR)$(PREFIX)/share/man/man1/vidscribe.1 \
	      $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps/vidscribe.svg

clean:
	rm -rf debian/.debhelper debian/vidscribe debian/files debian/*.substvars debian/debhelper-build-stamp
