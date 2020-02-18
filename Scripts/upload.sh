#!/usr/bin/env sh

set -euo pipefail

xcrun altool --validate-app -f ${XCS_PRODUCT} -u $APPLE_ID -p $APPLE_ID_PW
xcrun altool --upload-app -f ${XCS_PRODUCT} -u $APPLE_ID -p $APPLE_ID_PW
