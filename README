## example of a simple package

```make
PKG_NAME	:= test1
PKG_SOURCE	:= $(TOP_DIR)/test1 # a url to git repo
PKG_BRANCH	:= HEAD
PKG_VERSION	:= v0.0.0
PKG_DEPENDS := test2

include $(PKG_MGR)/package.mk

define Package/Build
	$(MAKE) -C $(PKG_BUILD)
endef

$(eval $(call Package))
```

## Extra traces can be enabled with V=sc parameter
```sh
make V=sc
```
