# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2022 NagaseKouichi

include $(TOPDIR)/rules.mk

PKG_NAME:=mosdns-cn
PKG_VERSION:=1.2.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/IrineSistiana/mosdns-cn/tar.gz/v${PKG_VERSION}?
PKG_HASH:=e4588e1d365c32d9fd0bdef3f366a231f72a6f7a8c5023241e04c86d2ecc0c8f

PKG_LICENSE:=MIT
PKG_LICENSE_FILE:=LICENSE
PKG_MAINTAINER:=NagaseKouichi

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/IrineSistiana/mosdns-cn
GO_PKG_LDFLAGS:=-s -w
GO_PKG_BUILD_PKG:=$(GO_PKG)
GO_PKG_LDFLAGS_X:=main.appVersion=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/mosdns-cn
  SECTION:=net
  CATEGORY:=Network
  TITLE:=mosdns-cn, another simple to use DNS dispatcher/forwarder
  URL:=https://github.com/IrineSistiana/mosdns-cn
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/mosdns-cn/description
  mosdns-cn is another simple to use DNS dispatcher/forwarder.
endef

define Package/mosdns-cn/conffiles
/etc/config/mosdns-cn
/etc/mosdns-cn/
endef

define Package/mosdns-cn/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mosdns-cn $(1)/usr/bin/mosdns-cn
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(1)/usr/bin/mosdns-cn || true
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/mosdns-cn.config $(1)/etc/config/mosdns-cn
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/mosdns-cn.init $(1)/etc/init.d/mosdns-cn
	$(INSTALL_DIR) $(1)/etc/mosdns-cn
	$(INSTALL_DATA) ./files/dat/* $(1)/etc/mosdns-cn
endef

define Package/mosdns-cn/postrm
#!/bin/sh
rmdir --ignore-fail-on-non-empty /etc/mosdns-cn
exit 0
endef

$(eval $(call GoBinPackage,mosdns-cn))
$(eval $(call BuildPackage,mosdns-cn))
