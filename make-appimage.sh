#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q ptyxis | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.gnome.Ptyxis.svg
export DESKTOP=/usr/share/applications/org.gnome.Ptyxis.desktop
export DEPLOY_GTK=1

export PATH_MAPPING='
  /usr/lib/ptyxis-agent:${SHARUN_DIR}/bin/ptyxis-agent
'

# Deploy dependencies
quick-sharun \
              /usr/bin/ptyxis  \
              /usr/lib/ptyxis-agent  \

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
