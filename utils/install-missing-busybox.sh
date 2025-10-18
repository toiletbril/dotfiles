#!/bin/sh
#
# Installs links to busybox's applets for each applet that exists in a busybox
# build and is missing from \$PATH.

echo "This script will install links to busybox's applets for each applet that exists"
echo "in your busybox build and is missing from your \$PATH."
read -p "Are you sure you want to continue? [Y/n] " response

if ! [ $response =~ [yY][eE][sS]|[yY]|[jJ] ]; then
    exit 1
fi

BB_TMP="tmp_busybox"

mkdir ./$BB_TMP && busybox --install -s ./$BB_TMP

for item in $(ls "./$BB_TMP"); do
    if ! [ $(which "$item") ]; then
        echo "Installing '$item'..."
        mv -i ./$BB_TMP/$item /usr/bin/$item
    fi
done

rm -r $BB_TMP
