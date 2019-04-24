#!/bin/sh
if [ "${USER}" != "root" ]; then
    echo "Permission denied, try rerunning as root"
    exit 1
fi

WORKSPACE="$(cd "$(dirname "$0")" && pwd)"
PKG_DIR=""

# 复制图标
mkdir -p ${PKG_DIR}/usr/share/mime/packages
cp ${WORKSPACE}/drawio.xml ${PKG_DIR}/usr/share/mime/packages
mkdir -p ${PKG_DIR}/usr/share/pixmaps/
cp ${WORKSPACE}/drawio-file.svg ${PKG_DIR}/usr/share/pixmaps/

# 更新缓存
echo "[setup] Updating mime database...."
update-mime-database ${PKG_DIR}/usr/share/mime

echo "[setup] Done."