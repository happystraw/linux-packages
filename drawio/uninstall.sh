#!/bin/sh

PKG_DIR=""

# 删除图标
rm ${PKG_DIR}/usr/share/mime/packages/drawio.xml
rm ${PKG_DIR}/usr/share/pixmaps/drawio-file.svg

# 更新缓存
echo "[setup] Updating mime database...."
update-mime-database ${PKG_DIR}/usr/share/mime

echo "[setup] Uninstall done."