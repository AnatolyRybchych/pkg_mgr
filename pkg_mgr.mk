ifeq ($(PKG_MGR_SLAVE),)

ifeq ($(TOP_DIR),)
TOP_DIR:=$(realpath .)
endif

export TOP_DIR
export PKG_REGISTRY_DIR		:=	$(TOP_DIR)/packages
export PACKAGES_DIR			:=	$(TOP_DIR)/package
export BUILD_DIR			:=	$(TOP_DIR)/build
export PKG_MGR				:=	$(TOP_DIR)/pkg_mgr

include $(PKG_MGR)/fancy.mk

PACKAGE_MAKEFILES			:= $(wildcard $(PKG_REGISTRY_DIR)/*.mk)

export ORIGINAL_MAKEFLAGS	:=$(MAKEFLAGS)
ifeq ($(V),)
# MAKEFLAGS += --no-print-directory
MAKEFLAGS += -s
endif

define Package/Undefine
export PKG_MAKEFILE:=
export PKG_MGR_INCUDE:=
export PKG_NAME:=
export PKG_VERSION:=
export PKG_SOURCE:=
export PKG_BRANCH:=
export PKG_FULL_NAME:=
export PKG_DIR:=
export PKG_BUILD:=
export PKG_DEPENDS:=
endef

define Package/DependencyTree
all: package/$(2)
package/$(2): package/$(2)/build

clean: package/$(2)/clean
package/$(2)/clean:
	$(call LogImportant,package/$(2)/clean)
	$(MAKE) -f $(1) clean

download: package/$(2)/download
package/$(2)/download:
	$(call LogImportant,package/$(2)/download)
	$(MAKE) -f $(1) download

build: package/$(2)/build
package/$(2)/build: $(patsubst <dependency>, package/<dependency>/build, $(3))
	$(call LogImportant,package/$(2)/build)
	$(MAKE) -f $(1) build

endef

define Package/Define
PKG_MAKEFILE	:= $(1)
PKG_MGR_INCUDE	:=yes
include $$(PKG_MAKEFILE)

export Package/$$(PKG_NAME)/Build	:=$(PKG_BUILD)

$$(eval $$(call Package/DependencyTree,$$(PKG_MAKEFILE),$$(PKG_NAME),$$(PKG_DEPENDS)))
endef

all:

clean:
	rm -rf $(BUILD_DIR)

$(foreach package, $(PACKAGE_MAKEFILES), $(eval $(call Package/Define, $(package))))

.PHONY: all clean download build

export PKG_MGR_SLAVE:=yes
endif

