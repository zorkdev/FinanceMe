#!/usr/bin/env sh

set -euo pipefail

PLATFORM=$1

case $PLATFORM in
iOS) DESTINATION="platform=iOS Simulator,name=iPhone 11 Pro";;
tvOS) DESTINATION="platform=tvOS Simulator,name=Apple TV 4K";;
macOS) DESTINATION="platform=macOS,arch=x86_64";;
esac

xcodebuild clean \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-$PLATFORM

xcodebuild build \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-$PLATFORM \
    -destination "$DESTINATION" \
    > build.log

sh Scripts/swiftlint.sh analyze \
    --config .swiftlint_analyze.yml \
    --compiler-log-path build.log \
    --reporter emoji

rm build.log
