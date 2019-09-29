#!/bin/bash

xcodebuild clean \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-iOS

xcodebuild build \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-iOS \
    -UseModernBuildSystem=NO \
    -destination 'platform=iOS Simulator,name=iPhone 11 Pro' \
    > build.log

mint run swiftlint swiftlint analyze \
    --config .swiftlint_analyze.yml \
    --compiler-log-path build.log \
    --reporter html > report.html
