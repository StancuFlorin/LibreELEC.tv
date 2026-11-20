# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rtw88-rtl8723bs"
PKG_VERSION="0f64b72d8ec091d811a1a44f8b314e9df1b72d78"
PKG_SHA256="3c5c8de76917fc6bcd909729260c10315aad889478a59c21000607ec93b3f838"
PKG_LICENSE="GPL-2.0-only OR BSD-3-Clause"
PKG_SITE="https://github.com/MocLG/rtw88-rtl8723bs"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_NEED_UNPACK="$(get_pkg_directory linux)"
PKG_LONGDESC="Out-of-tree Realtek RTL8723BS SDIO wireless driver"
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="manual"

make_target() {
  kernel_make -C "$(kernel_path)" M="${PKG_BUILD}" modules
}

makeinstall_target() {
  local module_dir="${INSTALL}/$(get_full_module_dir)/updates/${PKG_NAME}"
  local firmware_dir="${INSTALL}/$(get_full_firmware_dir)/rtw88"

  mkdir -p "${module_dir}"
  for module in rtw_core rtw_8723x rtw_8723b rtw_sdio rtw_8723bs; do
    install -m 0644 "${PKG_BUILD}/${module}.ko" "${module_dir}"
    ${TARGET_KERNEL_PREFIX}strip --strip-debug "${module_dir}/${module}.ko"
  done

  mkdir -p "${firmware_dir}"
  install -m 0644 "${PKG_BUILD}/firmware/rtw8723b_fw.bin" "${firmware_dir}"
}
