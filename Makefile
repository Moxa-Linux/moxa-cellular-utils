DIST = unstable
VERSION = $(shell cat ./sbin/cell_mgmt | grep "^VERSION=" | sed "s/VERSION=//")

all:
	@echo "$(VERSION)"

install:
	mkdir -p $(DESTDIR)/sbin
	mkdir -p $(DESTDIR)/etc/
	cp -arf sbin/* $(DESTDIR)/sbin/
	cp -arf etc/* $(DESTDIR)/etc/

clean:


changelog:
	dch -v $(VERSION) -D $(DIST) -M -u low --release-heuristic log

deb:
	dpkg-buildpackage -us -uc -rfakeroot
