#!/bin/bash

# asar (yarn / npm 安装或系统包管理安装)
ASAR_BIN="asar"

# 安装路径
SRC_PATH="/opt/XMind"
SRC_APP_ASAR="${SRC_PATH}/resources/app.asar"
SRC_ASAR_UNPACKED="${SRC_PATH}/resources/app.asar.unpacked"

# 解压路径
CURRENT_PATH=$(dirname $0)
TARGET_APP_ASAR="${CURRENT_PATH}/app.asar"
TARGET_APP_ASAR_TMP="${CURRENT_PATH}/app.asar.tmp"
TARGET_ASAR_UNPACKED="${CURRENT_PATH}/app.asar.unpacked"

# 临时破解文件
CRACKED_FILE="${CURRENT_PATH}/common.tmp.js"

function clean() {
    rm -rf ${TARGET_APP_ASAR} ${TARGET_ASAR_UNPACKED} ${TARGET_APP_ASAR_TMP}
}

function copy_resources() {
    cp -r ${SRC_APP_ASAR} ${SRC_ASAR_UNPACKED} ${CURRENT_PATH}
}

function crack_resources() {
    ${ASAR_BIN} e ${TARGET_APP_ASAR} ${TARGET_APP_ASAR_TMP}

    sed -E 's/<svg width="16" height="16" viewBox="0 0 16 16"/<svg width="SIXTEEN_TMP" height="SIXTEEN_TMP" viewBox="0 0 SIXTEEN_TMP SIXTEEN_TMP"/g' ${TARGET_APP_ASAR_TMP}/renderer/common.js |
        sed -E 's/<svg width="[0-9]+" height="[0-9]+" viewBox="0 0 [0-9]+ [0-9]+"/<svg width="0" height="0" viewBox="0 0 0 0"/g' |
        sed 's/SIXTEEN_TMP/16/g' >${CRACKED_FILE}

    mv ${CRACKED_FILE} ${TARGET_APP_ASAR_TMP}/renderer/common.js

    ${ASAR_BIN} p ${TARGET_APP_ASAR_TMP} ${CURRENT_PATH}/app.asar.cracked
}

function replace_resources() {
    VERSION=$(grep '"version"' ${TARGET_APP_ASAR_TMP}/package.json | cut -d'"' -f 4)

    [[ ! -f "${SRC_APP_ASAR}.backup.v${VERSION}" ]] && sudo mv ${SRC_APP_ASAR} "${SRC_APP_ASAR}.backup.v${VERSION}"

    sudo mv ${CURRENT_PATH}/app.asar.cracked ${SRC_APP_ASAR}
}

clean
copy_resources
crack_resources
replace_resources
clean
