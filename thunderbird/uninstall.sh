#!/bin/bash

PKG_NAME="thunderbird"
PKG_DIR=""

echo "[setup] Removing package...."

rm -rf ${PKG_DIR}/opt/${PKG_NAME}
rm ${PKG_DIR}/usr/local/bin/thunderbird
rm ${PKG_DIR}/usr/share/pixmaps/thunderbird.png
rm ${PKG_DIR}/usr/share/applications/thunderbird.desktop

echo "[setup] Uninstall done."