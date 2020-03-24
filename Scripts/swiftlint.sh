#!/usr/bin/env sh

set -euo pipefail

unset SDKROOT
PACKAGE=swiftlint
PINNED_VERSION=$(Tools/Sources/Tools/main.swift $PACKAGE)
PRODUCT_DIR=Tools/.build/cache/$PACKAGE/$PINNED_VERSION
PRODUCT=$PRODUCT_DIR/$PACKAGE

if [ ! -f $PRODUCT ]; then
    cd Tools
    swift build -c release -Xswiftc -suppress-warnings
    cd ..
    mkdir -p $PRODUCT_DIR
    cp Tools/.build/release/$PACKAGE $PRODUCT_DIR/
fi

$PRODUCT "$@"
