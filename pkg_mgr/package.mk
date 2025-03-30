
include $(PKG_MGR)/fancy.mk

ifeq ($(PKG_NAME),)
$(error PKG_NAME is not defined)
endif

ifeq ($(PKG_SOURCE),)
$(error PKG_SOURCE is not defined for $(PKG_NAME))
endif

ifeq ($(PKG_VERSION),)
PKG_VERSION:=v0.0.0
endif

ifeq ($(PKG_BRANCH),)
PKG_BRANCH	:=HEAD
endif

PKG_FULL_NAME	:= $(PKG_NAME)-$(PKG_VERSION)
PKG_DIR			:= $(PACKAGES_DIR)/$(PKG_FULL_NAME)
PKG_BUILD		:= $(BUILD_DIR)/$(PKG_FULL_NAME)

define Package
ifneq ($(PKG_MGR_INCUDE),yes)

build: $$(PKG_BUILD)
	$$(eval MAKEFLAGS:=$(ORIGINAL_MAKEFLAGS))
	$$(call Package/Build)

clean:
	[ -d $$(PKG_DIR) ] && touch $$(PKG_DIR) || :

download: $$(PKG_DIR)
	$$(eval MAKEFLAGS:=$(ORIGINAL_MAKEFLAGS))
	$$(call Package/donwload)

$$(PKG_DIR):
	@mkdir -p $$(PKG_DIR)
ifeq ($(findstring B,$(MAKEFLAGS)),B)
	rm -rf $$(PKG_DIR)
endif
	git clone $$(PKG_SOURCE) $$(PKG_DIR)

$$(PKG_BUILD): $$(PKG_DIR)
	$(call LogImportant,package/$(PKG_NAME)/build)
	@mkdir -p $$(PKG_BUILD)
	rm -rf $$(PKG_BUILD)
	cp -rf $$(PKG_DIR)/. $$(PKG_BUILD)
	cd $$(PKG_BUILD) && git checkout $$(PKG_BRANCH)

.PHONY: all clean download build
endif
endef
