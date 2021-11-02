#!/bin/bash

set -euo pipefail

THIS_DIR=$(cd -P "$(dirname "$(readlink "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}")")" && pwd)
PACKAGE_VERSION=$(cat "${THIS_DIR}/../package.json" \
  | grep "\"version\":" \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')
WEBRTC_DL="https://github.com/react-native-webrtc/react-native-webrtc/releases/download/${PACKAGE_VERSION}/WebRTC.tar.xz"
CACHED_DIR=~/.cache
echo ${CACHED_DIR}
CACHED_FILE="${CACHED_DIR}/WebRTC-${PACKAGE_VERSION}.tar.xz"


pushd "${THIS_DIR}/../apple"

# Cleanup
rm -rf WebRTC.xcframework WebRTC.dSYMs

# Download
echo "Downloading files..."
echo $PACKAGE_VERSION
if [ -d "$CACHED_DIR" ]
then
  echo "Using Cache from ${CACHED_FILE}"
  [ -e "${CACHED_FILE}" ] || ( echo "Priming Cache..." && curl -L -s ${WEBRTC_DL} -o "${CACHED_FILE}")
  tar Jxf "${CACHED_FILE}"
else
  echo curl -L -s ${WEBRTC_DL} | tar Jxf -
fi
echo "Done!"

popd
