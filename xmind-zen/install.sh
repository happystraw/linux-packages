#!/bin/bash
if [ "${USER}" != "root" ]; then
    echo "Permission denied, try rerunning as root"
    exit 1
fi

WORKSPACE="$(cd "$(dirname "$0")" && pwd)"

PKG_DIR=""
IMG_PATH="${PKG_DIR}/opt/XMind ZEN/resources/app/out/imgs"

install() {
    # 替换导出 PNG 水印
    echo "[setup] Replace watermarsk png"
    cp "${WORKSPACE}/pdf-sub-footer.svg" "${IMG_PATH}/pdf-sub-footer.svg"
    for LANG in "de-DE" "en-US" "fr-FR" "ja-JP" "zh-CN" "zh-TW"
    do
        cp "${WORKSPACE}/png-watermark.svg" "${IMG_PATH}/png-watermark-${LANG}.svg"
        cp "${WORKSPACE}/pdf-footer.svg" "${IMG_PATH}/pdf-footer-${LANG}.svg"
        cp "${WORKSPACE}/print-watermark.svg" "${IMG_PATH}/print-watermark-${LANG}.svg"
    done

    # 复制图标
    echo "[setup] Copying mime type resource ..."
    mkdir -p "${PKG_DIR}/usr/share/mime/packages"
    cp "${WORKSPACE}/xmind.xml" "${PKG_DIR}/usr/share/mime/packages"
    mkdir -p "${PKG_DIR}/usr/share/pixmaps/"
    cp "${WORKSPACE}/xmind_file.png" "${PKG_DIR}/usr/share/pixmaps/"


    # 设置 mime
    echo "[setup] Updating mime database ..."
    update-mime-database "${PKG_DIR}/usr/share/mime"

    echo "[setup] Done."
}

install
