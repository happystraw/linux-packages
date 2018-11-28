#!/bin/bash
WORKSPACE="$(cd "$(dirname "$0")" && pwd)"

PKG_NAME="xmind"
PKG_DIR=""

echo "[setup] Removing package...."
rm ${PKG_DIR}/usr/local/bin/XMind
rm ${PKG_DIR}/usr/share/applications/xmind.desktop
rm ${PKG_DIR}/usr/share/mime/packages/xmind.xml
rm ${PKG_DIR}/usr/share/pixmaps/xmind.png
rm ${PKG_DIR}/usr/share/pixmaps/xmind_file.png
rm -rf ${PKG_DIR}/opt/${PKG_NAME}
rm -rf ${PKG_DIR}/usr/share/fonts/truetype/xmind
echo "[setup] Updating mime database...."
update-mime-database ${PKG_DIR}/usr/share/mime
echo "[setup] Rebuilding fonts cache...."
fc-cache -f

echo "[setup] Uninstall done."