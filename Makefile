PROJECT = moxa-cellular-utils
PROJECT_CONF_DIR=/etc/${PROJECT}
VERSION = $(shell cat ./cell_mgmt | grep "^VERSION=" | sed "s/VERSION=//")
DIST    ?= unstable
DISTDIR = $(PROJECT)-$(VERSION)
ARCHIVE = $(CURDIR)/$(DISTDIR).tar.gz

STAGING_DIR = $(CURDIR)/staging
PROJECT_STAGING_DIR = $(STAGING_DIR)/$(DISTDIR)

IN_FILES= \
	etc/ppp/ip-up.d/${PROJECT}.in \
	etc/ppp/ip-down.d/${PROJECT}.in \
	etc/dhcp/dhclient-enter-hooks.d/${PROJECT}.in \
	etc/dhcp/dhclient-exit-hooks.d/${PROJECT}.in
OUT_FILES=$(IN_FILES:.in=)
DIST_FILES = \
	$(IN_FILES) \
	etc/ppp/ip-up.d/0000usepeerdns \
	etc/ppp/ip-down.d/0000usepeerdns \
	etc/udhcpc/default.script \
	etc/udhcpc/ignore-gw-dns.script \
	etc/${PROJECT}/${PROJECT}.conf \
	etc/${PROJECT}/product.d \
	etc/${PROJECT}/module.d \
	etc/${PROJECT}/qmicli-profile-scan.awk \
	etc/${PROJECT}/ip-up.d/connected \
	etc/${PROJECT}/ip-down.d/disconnected \
	etc/${PROJECT}/ppp/peers/wvdial.template \
	etc/${PROJECT}/ppp/peers/wvdial-huawei.example \
	etc/${PROJECT}/wvdial/wvdial.conf.template \
	etc/${PROJECT}/wvdial/mc73xx.conf.example \
	etc/${PROJECT}/wvdial/huawei.conf.example \
	cell_mgmt \
	cell-signald \
	debian \
	Makefile

STAGING_FILES=$(addprefix $(PROJECT_STAGING_DIR)/,$(DIST_FILES))
BUILD_DATE:=$(shell date +%Y%m%d-%H%M%S)

replace = sed -e 's|@conf_dir@|$(PROJECT_CONF_DIR)|g'


all: $(OUT_FILES)
	@echo "$(VERSION)"

$(OUT_FILES):
	@$(replace) $@.in >$@
	@chmod a+x $@
	@rm $@.in

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

.PHONY: all clean install distclean dist
