#!/bin/sh

/usr/bin/ditto -c -k --keepParent $XCS_PRODUCT $XCS_OUTPUT_DIR/FinanceMe.app.zip

xcrun altool --notarize-app \
    --primary-bundle-id com.zorkdev.FinanceMe \
    -itc_provider WX9VZ58J6W
    -f $XCS_OUTPUT_DIR/FinanceMe.app.zip \
    -u $APPLE_ID -p $APPLE_ID_PW \

sleep 120

xcrun stapler staple $XCS_PRODUCT || true
