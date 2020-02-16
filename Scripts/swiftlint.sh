#!/bin/bash

build () {
    cd Tools
    swift build -c release
    cd ..
}

SWIFTLINT="Tools/.build/release/swiftlint"

if [ ! -f "$SWIFTLINT" ]; then
    build
else
    PINNED_VERSION=$(Tools/Sources/Tools/main.swift SwiftLint)
    VERSION=$($SWIFTLINT version)

    if [ $VERSION != $PINNED_VERSION ]; then
        build
    fi
fi

$SWIFTLINT "$@"
