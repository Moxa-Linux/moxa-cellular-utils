PROJECT = moxa-cellular-utils
VERSION = $(shell cat ./cell_mgmt | grep "^VERSION=" | sed "s/VERSION=//")
DIST    ?= unstable
DISTDIR = $(PROJECT)-$(VERSION)
ARCHIVE = $(CURDIR)/$(DISTDIR).tar.gz

STAGING_DIR = $(CURDIR)/staging
PROJECT_STAGING_DIR = $(STAGING_DIR)/$(DISTDIR)

DIST_FILES = \
	etc \
	cell_mgmt \
	Makefile

STAGING_FILES=$(addprefix $(PROJECT_STAGING_DIR)/,$(DIST_FILES))
BUILD_DATE:=$(shell date +%Y%m%d-%H%M%S)

all:
	@echo "$(VERSION)"

dist: $(ARCHIVE)

$(ARCHIVE): distclean $(STAGING_FILES)
	@mkdir -p $(STAGING_DIR)
	cd $(STAGING_DIR) && \
		tar zcf $@ $(DISTDIR)

$(PROJECT_STAGING_DIR)/%: %
	@mkdir -p $(dir $@)
	@cp -a $< $@

clean:
	rm -rf $(DISTDIR)* $(STAGING_DIR)

distclean: clean
