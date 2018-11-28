#!/bin/bash
WORKSPACE="$(cd "$(dirname "$0")" && pwd)"

PKG_DIR=""

echo "[setup] Removing mime type resource ..."
rm ${PKG_DIR}/usr/share/mime/packages/xmind.xml
rm ${PKG_DIR}/usr/share/pixmaps/xmind_file.png
echo "[setup] Updating mime database ..."
update-mime-database ${PKG_DIR}/usr/share/mime

echo "[setup] Uninstall done."