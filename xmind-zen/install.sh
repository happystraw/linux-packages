#!/bin/bash

WORKSPACE="$(cd "$(dirname "$0")" && pwd)"

PKG_DIR=""

install() {
    # 复制图标
    echo "[setup] Copying mime type resource ..."
    mkdir -p ${PKG_DIR}/usr/share/mime/packages
    cp ${WORKSPACE}/xmind.xml ${PKG_DIR}/usr/share/mime/packages
    mkdir -p ${PKG_DIR}/usr/share/pixmaps/
    cp ${WORKSPACE}/*.png ${PKG_DIR}/usr/share/pixmaps/

    # 设置 mime
    echo "[setup] Updating mime database ..."
    update-mime-database ${PKG_DIR}/usr/share/mime

    echo "[setup] Done."
}

install
