#!/bin/bash

SWIFTLINT="Tools/.build/release/swiftlint"

if [ ! -f "$SWIFTLINT" ]; then
    cd Tools
    swift build -c release
    cd ..
fi

$SWIFTLINT
