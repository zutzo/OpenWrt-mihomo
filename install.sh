#!/bin/sh

# MihomoTProxy's installer

# check env
if [[ ! -x "/bin/opkg" || ! -x "/sbin/fw4" ]]; then
    echo "Only supports OpenWrt build with firewall4!"
    exit 1
fi
if [ ! -x "/usr/sbin/nft" ]; then
    echo "Only supports firewall4 with nftables!"
    exit 1
fi

# get arch
arch=$(opkg print-architecture | grep -v all | grep -v noarch | head -n 1 | cut -d ' ' -f 2)

# check if arch is supported
if [ "$arch" != "x86_64" ] && [ "$arch" != "aarch64_generic" ]; then
    echo "Unsupported architecture: $arch"
    exit 1
fi

# define tarball
tarball="mihomo_${arch}.tar.gz"

# download
echo "Downloading..."
curl -L -s -o "$tarball" "https://github.com/zutzo/OpenWrt-mihomo/raw/files/$tarball"
if [ "$?" != 0 ]; then
    echo "Download failed, check your internet connectivity."
    exit 1
fi

# extract
echo "Extracting..."
tar -zxf "$tarball"
if [ "$?" != 0 ]; then
    echo "Extract failed, broken compressed file?"
    exit 1
fi
rm -f "./$tarball"

# install based on input parameter
echo "Installing..."
case "$1" in
    1)
        opkg -V0 install mihomo_*.ipk && opkg -V0 install luci-app-mihomo_*.ipk && opkg -V0 install luci-i18n-mihomo-zh-cn_*.ipk
        ;;
    0|"")
        opkg -V0 install mihomo_*.ipk
        ;;
    *)
        echo "Usage: $0 [0|1]"
        echo "0 or empty: Install mihomo only"
        echo "1: Install mihomo and LuCI components"
        exit 1
        ;;
esac

if [ "$?" != 0 ]; then
    echo "Install failed."
    exit 1
fi

# cleanup
rm -f ./mihomo_*.tar.gz
rm -f ./*mihomo*.ipk

echo "Installation completed successfully."
