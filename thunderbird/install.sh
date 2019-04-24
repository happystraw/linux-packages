#!/bin/bash
if [ "${USER}" != "root" ]; then
    echo "Permission denied, try rerunning as root"
    exit 1
fi

WORKSPACE="$(cd "$(dirname "$0")" && pwd)"

PKG_NAME="thunderbird"
PKG_DIR=""
FILENAME=${PKG_NAME}
VERSION="60.2.1"
OS_ARCH="$(uname -m)"

# 资源地址
SOURCE="https://download.mozilla.org/?product=thunderbird-${VERSION}-SSL&os=linux&lang=en-US"
if [[ "$OS_ARCH" == "x86_64" ]]; then
    SOURCE="https://download.mozilla.org/?product=thunderbird-${VERSION}-SSL&os=linux64&lang=en-US"
fi

# 下载文件
if [ ! -f "${FILENAME}.tar.bz2" ]; then
    echo "[setup] Downloading source file..."
    wget ${SOURCE} --max-redirect 3 -O ${FILENAME}.tar.bz2
fi

if [[ $? != 0 ]];then
    echo "[setup] Downloading source file fail."
    rm "${FILENAME}.tar.bz2"
    exit 1
fi

echo "[setup] Extract archive...."
rm -rf ${WORKSPACE}/thunderbird
tar -xf thunderbird.tar.bz2

if [[ $? != 0 ]];then
    echo "[setup] Extract error, try remove ${FILENAME}.tar.bz2, and install again."
    exit 2
fi

echo "[setup] Installing package...."
mkdir -p ${PKG_DIR}/opt/${PKG_NAME}
cp -r ${WORKSPACE}/thunderbird/* ${PKG_DIR}/opt/${PKG_NAME}

mkdir -p ${PKG_DIR}/usr/share/applications
cp ${WORKSPACE}/thunderbird.desktop ${PKG_DIR}/usr/share/applications

mkdir -p ${PKG_DIR}/usr/share/pixmaps/
cp ${WORKSPACE}/thunderbird.png ${PKG_DIR}/usr/share/pixmaps/

mkdir -p ${PKG_DIR}/usr/local/bin
ln -sf ${PKG_DIR}/opt/${PKG_NAME}/thunderbird ${PKG_DIR}/usr/local/bin/thunderbird

# 如需要支持软件内部自动更新, 文件路径添加权限即可
# chown -R "${USER}:${USER}" ${PKG_DIR}/opt/${PKG_NAME}

rm -rf ${WORKSPACE}/thunderbird

echo "[setup] Done."
