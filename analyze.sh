#!/bin/bash

xcodebuild clean \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-iOS

xcodebuild build \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-iOS \
    -destination 'platform=iOS Simulator,name=iPhone 11 Pro' \
    > build.log || true

/usr/local/bin/mint run swiftlint swiftlint analyze \
    --config .swiftlint_analyze.yml \
    --compiler-log-path build.log \
    --reporter emoji || true
