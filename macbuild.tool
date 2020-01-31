#!/bin/bash

BUILDDIR=$(dirname "$0")
pushd "$BUILDDIR" >/dev/null
BUILDDIR=$(pwd)
popd >/dev/null

NASMVER="2.13.03"

# For nasm in Xcode
export PATH="/opt/local/bin:/usr/local/bin:$PATH"

cd "$BUILDDIR"

prompt() {
    echo "$1"
    if [ "$FORCE_INSTALL" != "1" ]; then
        read -p "Enter [Y]es to continue: " v
        if [ "$v" != "Y" ] && [ "$v" != "y" ]; then
            exit 1
        fi
    fi
}

updaterepo() {
    if [ ! -d "$3" ]; then
        git clone "$1" -b "$2" --depth=1 "$3" || exit 1
    fi
    pushd "$3" >/dev/null
    git pull
    popd >/dev/null
}

if [ "$BUILDDIR" != "$(printf "%s\n" $BUILDDIR)" ]; then
    echo "EDK2 build system may still fail to support directories with spaces!"
    exit 1
fi

# Check that Xcode is actually installed.
if [ "$(which clang)" = "" ] || [ "$(which git)" = "" ] || [ "$(clang -v 2>&1 | grep "no developer")" != "" ] || [ "$(git -v 2>&1 | grep "no developer")" != "" ]; then
    echo "Missing Xcode tools, please install them!"
    exit 1
fi

# Get nasm if needed.
if [ "$(nasm -v)" = "" ] || [ "$(nasm -v | grep Apple)" != "" ]; then
    echo "Missing or incompatible nasm!"
    echo "Download the latest nasm from http://www.nasm.us/pub/nasm/releasebuilds/"
    prompt "Last tested with nasm $NASMVER. Install it automatically?"
    pushd /tmp >/dev/null
    rm -rf "nasm-${NASMVER}-macosx.zip" "nasm-${NASMVER}"
    curl -OL "http://www.nasm.us/pub/nasm/releasebuilds/${NASMVER}/macosx/nasm-${NASMVER}-macosx.zip" || exit 1
    unzip -q "nasm-${NASMVER}-macosx.zip" "nasm-${NASMVER}/nasm" "nasm-${NASMVER}/ndisasm" || exit 1
    sudo mkdir -p /usr/local/bin || exit 1
    sudo mv "nasm-${NASMVER}/nasm" /usr/local/bin/ || exit 1
    sudo mv "nasm-${NASMVER}/ndisasm" /usr/local/bin/ || exit 1
    rm -rf "nasm-${NASMVER}-macosx.zip" "nasm-${NASMVER}"
    popd >/dev/null
fi

# Get mtoc if needed. This is used for converting to PE from mach-o.
if [ "$(which mtoc.NEW)" == "" ] || [ "$(which mtoc)" == "" ]; then
    echo "Missing mtoc or mtoc.NEW!"
    echo "To build mtoc follow: https://github.com/tianocore/tianocore.github.io/wiki/Xcode#mac-os-x-xcode"
    prompt "Install prebuilt mtoc and mtoc.NEW automatically?"
    rm -f mtoc mtoc.NEW
    unzip -q external/mtoc-mac64.zip mtoc.NEW || exit 1
    sudo mkdir -p /usr/local/bin || exit 1
    sudo cp mtoc.NEW /usr/local/bin/mtoc || exit 1
    sudo mv mtoc.NEW /usr/local/bin/ || exit 1
fi

# Create binaries folder if needed.
if [ ! -d "Binaries" ]; then
    mkdir Binaries || exit 1
    cd Binaries || exit 1
    ln -s ../UDK/Build/UsbDumpEfiPkg/RELEASE_XCODE5/X64 RELEASE || exit 1
    ln -s ../UDK/Build/UsbDumpEfiPkg/DEBUG_XCODE5/X64 DEBUG || exit 1
    cd .. || exit 1
fi

# Get mode.
if [ "$1" != "" ]; then
    MODE="$1"
    shift
fi

if [ ! -f UDK/UDK.ready ]; then
    rm -rf UDK
fi

# Clone EDK2.
updaterepo "https://github.com/tianocore/edk2" UDK2018 UDK || exit 1
cd UDK

# EDK2 can only build packages in its folder, so link UsbDumpEfiPkg there.
if [ ! -d UsbDumpEfiPkg ]; then
    ln -s .. UsbDumpEfiPkg || exit 1
fi

# Setup EDK2.
source edksetup.sh || exit 1
make -C BaseTools || exit 1
touch UDK.ready

# Build debug binaries.
if [ "$MODE" = "" ] || [ "$MODE" = "DEBUG" ]; then
    build -a X64 -b DEBUG -t XCODE5 -p UsbDumpEfiPkg/UsbDumpEfiPkg.dsc || exit 1
fi

# Build release binaries.
if [ "$MODE" = "" ] || [ "$MODE" = "RELEASE" ]; then
    build -a X64 -b RELEASE -t XCODE5 -p UsbDumpEfiPkg/UsbDumpEfiPkg.dsc || exit 1
fi
