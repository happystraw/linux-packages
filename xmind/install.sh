#!/bin/bash
if [ "${USER}" != "root" ]; then
    echo "Permission denied, try rerunning as root"
    exit 1
fi

# GTK_VERSION 2/3
GTK_VERSION=3
# JAVA_VERSION 8/10
JAVA_VERSION=8
# JAVA_PATH
#JAVA_PATH='/usr/lib/jvm/default-runtime/bin/java'

WORKSPACE="$(cd "$(dirname "$0")" && pwd)"

PKG_NAME="xmind"
PKG_DIR=""
PKG_SRC="${WORKSPACE}/src"
FILENAME="${PKG_NAME}-8-update8-linux"
SOURCE="https://www.xmind.cn/xmind/downloads/${FILENAME}.zip"
SHA512SUM="77c5c05801f3ad3c0bf5550fa20c406f64f3f5fa31321a53786ac1939053f5c4f0d0fb8ab1af0a9b574e3950342325b9c32cf2e9a11bf00a1d74d2be1df75768"
OS_ARCH="$(uname -m)"

install() {
    # 下载文件
    if [ ! -f "${FILENAME}.zip" ]; then
        echo "[setup] Downloading source file..."
        wget ${SOURCE} --max-redirect 3 -O ${FILENAME}.zip
    fi

    # 校验文件
    CUR_SHA512SUM="$(sha512sum ${FILENAME}.zip | awk '{print $1}')"
    if [[ "${CUR_SHA512SUM}" != "${SHA512SUM}" ]]; then
        echo "[setup] Expect file sha512sum: ${SHA512SUM} , current file sha512sum: ${CUR_SHA512SUM} ."
        exit 1
    fi

    # 解压文件
    echo "[setup] Extract archive...."
    rm -rf "${PKG_SRC}"
    unzip -q -d "${PKG_SRC}" "${FILENAME}.zip"

    # 创建安装路径
    mkdir -p "${PKG_DIR}/opt/${PKG_NAME}"

    # 安装依赖
    echo "[setup] Installing dependencies...."
    apt install openjdk-8-jre libgtk2.0-0 libwebkitgtk-1.0-0 lame libc6 libglib2.0-0

    if [[ $? != 0 ]];then
        exit 1
    fi

    # 复制文件
    echo "[setup] Installing package...."
    cp -r ${PKG_SRC}/configuration "${PKG_DIR}/opt/${PKG_NAME}/"
    cp -r ${PKG_SRC}/features "${PKG_DIR}/opt/${PKG_NAME}/"
    cp -r ${PKG_SRC}/plugins "${PKG_DIR}/opt/${PKG_NAME}/"
    cp -r ${PKG_SRC}/*.xml "${PKG_DIR}/opt/${PKG_NAME}/"

    if [[ "$OS_ARCH" == "x86_64" ]]; then
        cp -r ${PKG_SRC}/XMind_amd64 "${PKG_DIR}/opt/${PKG_NAME}/XMind"
    else
        cp -r ${PKG_SRC}/XMind_i386 "${PKG_DIR}/opt/${PKG_NAME}/XMind"
    fi

    # 复制图标
    mkdir -p ${PKG_DIR}/usr/share/applications
    cp ${WORKSPACE}/xmind.desktop ${PKG_DIR}/usr/share/applications
    mkdir -p ${PKG_DIR}/usr/share/mime/packages
    cp ${WORKSPACE}/xmind.xml ${PKG_DIR}/usr/share/mime/packages
    mkdir -p ${PKG_DIR}/usr/share/pixmaps/
    cp ${WORKSPACE}/*.png ${PKG_DIR}/usr/share/pixmaps/

    # 安装字体
    echo "[setup] Installing fonts...."
    mkdir -p ${PKG_DIR}/usr/share/fonts/truetype/xmind
    rsync -av "${PKG_SRC}/fonts" ${PKG_DIR}/usr/share/fonts/truetype/xmind/
    echo "[setup] Rebuilding fonts cache...."
    fc-cache -f

    # 设置 mime
    echo "[setup] Updating mime database...."
    update-mime-database ${PKG_DIR}/usr/share/mime

    # 配置
    echo "[setup] Fixing configuration...."
    sed -i "s|^./configuration$|@user.home/.xmind/configuration|" ${PKG_DIR}/opt/${PKG_NAME}/XMind/XMind.ini
    sed -i "s|^../workspace$|@user.home/.xmind/workspace|" ${PKG_DIR}/opt/${PKG_NAME}/XMind/XMind.ini

    if [[ "${GTK_VERSION}" != "2" ]]; then
        sed -i "s|^2$|3|" ${PKG_DIR}/opt/${PKG_NAME}/XMind/XMind.ini
    fi
    if [[ "${JAVA_VERSION}" != "8" ]]; then
        echo "--add-modules=java.se.ee" >> ${PKG_DIR}/opt/${PKG_NAME}/XMind/XMind.ini
    fi
    if [[ "${JAVA_PATH}" != "" ]]; then
        sed -i "s|^-vmargs$|-vm\n${JAVA_PATH}\n-vmargs|" ${PKG_DIR}/opt/${PKG_NAME}/XMind/XMind.ini
    fi

    # 设置运行脚本
    mkdir -p ${PKG_DIR}/usr/local/bin
    cp ${WORKSPACE}/XMind ${PKG_DIR}/usr/local/bin

    rm -rf ${PKG_SRC}

    echo "[setup] Done."
}

install
